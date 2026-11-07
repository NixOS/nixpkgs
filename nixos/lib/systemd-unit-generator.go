package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
	"time"
)

// Config represents the input configuration for unit generation
type Config struct {
	OutDir          string              `json:"outDir"`
	TypeDir         string              `json:"typeDir"`
	PackageSource   string              `json:"packageSource"`
	UpstreamUnits   []string            `json:"upstreamUnits"`
	UpstreamWants   []string            `json:"upstreamWants"`
	Packages        []string            `json:"packages"`
	UnitsDropin     []string            `json:"unitsDropin"`     // asDropin strategy
	UnitsAutodetect []string            `json:"unitsAutodetect"` // asDropinIfExists strategy
	Aliases         map[string][]string `json:"aliases"`         // unit name -> list of aliases
	WantedBy        map[string][]string `json:"wantedBy"`        // unit name -> list of targets
	UpheldBy        map[string][]string `json:"upheldBy"`        // unit name -> list of targets
	RequiredBy      map[string][]string `json:"requiredBy"`      // unit name -> list of targets
	AllowCollisions bool                `json:"allowCollisions"`
	IsSystemType    bool                `json:"isSystemType"`
	DefaultUnit     string              `json:"defaultUnit,omitempty"`
	CtrlAltDelUnit  string              `json:"ctrlAltDelUnit,omitempty"`
	LndirPath       string              `json:"lndirPath"`
	Debug           bool                `json:"debug"`
}

var debug bool

func logDebug(format string, args ...interface{}) {
	if debug {
		fmt.Fprintf(os.Stderr, "[DEBUG] "+format+"\n", args...)
	}
}

func logTiming(phase string, start time.Time) {
	if debug {
		elapsed := time.Since(start)
		fmt.Fprintf(os.Stderr, "[TIMING] %s took %v\n", phase, elapsed)
	}
}

func main() {
	configFile := flag.String("config", "", "JSON configuration file")
	outDir := flag.String("out", "", "Output directory (overrides config file)")
	flag.Parse()

	if *configFile == "" {
		fmt.Fprintln(os.Stderr, "Error: -config flag is required")
		os.Exit(1)
	}

	data, err := os.ReadFile(*configFile)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading config file: %v\n", err)
		os.Exit(1)
	}

	var cfg Config
	if err := json.Unmarshal(data, &cfg); err != nil {
		fmt.Fprintf(os.Stderr, "Error parsing config JSON: %v\n", err)
		os.Exit(1)
	}

	// Override outDir if provided via command line
	if *outDir != "" {
		cfg.OutDir = *outDir
	}

	debug = cfg.Debug


	totalStart := time.Now()
	if err := generateUnits(cfg); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
	logTiming("Total execution", totalStart)
}

func generateUnits(cfg Config) error {
	// Create output directory
	if err := os.MkdirAll(cfg.OutDir, 0755); err != nil {
		return fmt.Errorf("failed to create output directory: %w", err)
	}

	// Phase 1: Copy upstream units
	start := time.Now()
	if err := copyUpstreamUnits(cfg); err != nil {
		return err
	}
	logTiming("Phase 1: Copy upstream units", start)

	// Phase 2: Copy upstream .wants links
	start = time.Now()
	if err := copyUpstreamWants(cfg); err != nil {
		return err
	}
	logTiming("Phase 2: Copy upstream .wants", start)

	// Phase 3: Symlink packages
	start = time.Now()
	if err := symlinkPackages(cfg); err != nil {
		return err
	}
	logTiming("Phase 3: Symlink packages", start)

	// Phase 4: Handle units with autodetect strategy
	start = time.Now()
	if err := handleUnitsAutodetect(cfg); err != nil {
		return err
	}
	logTiming("Phase 4: Handle autodetect units", start)

	// Phase 5: Handle units with dropin strategy
	start = time.Now()
	if err := handleUnitsDropin(cfg); err != nil {
		return err
	}
	logTiming("Phase 5: Handle dropin units", start)

	// Phase 6: Create aliases
	start = time.Now()
	if err := createAliases(cfg); err != nil {
		return err
	}
	logTiming("Phase 6: Create aliases", start)

	// Phase 7: Create .wants/.upholds/.requires
	start = time.Now()
	if err := createDependencies(cfg); err != nil {
		return err
	}
	logTiming("Phase 7: Create dependencies", start)

	// Phase 8: System-specific symlinks
	if cfg.IsSystemType {
		start = time.Now()
		if err := createSystemSymlinks(cfg); err != nil {
			return err
		}
		logTiming("Phase 8: System symlinks", start)
	}

	return nil
}

// Phase 1: Copy the upstream systemd units we're interested in
func copyUpstreamUnits(cfg Config) error {
	for _, unitName := range cfg.UpstreamUnits {
		fn := filepath.Join(cfg.PackageSource, "example/systemd", cfg.TypeDir, unitName)

		logDebug("Processing upstream unit: %s", fn)

		// Check if file exists
		info, err := os.Lstat(fn)
		if err != nil {
			return fmt.Errorf("missing %s: %w", fn, err)
		}

		outPath := filepath.Join(cfg.OutDir, filepath.Base(fn))

		// Check if output file already exists (handle duplicates in upstream list)
		if _, err := os.Lstat(outPath); err == nil {
			logDebug("Skipping %s - already exists", outPath)
			continue
		}

		if info.Mode()&os.ModeSymlink != 0 {
			// It's a symlink
			target, err := os.Readlink(fn)
			if err != nil {
				return fmt.Errorf("failed to read symlink %s: %w", fn, err)
			}

			// Check if target starts with ../
			if strings.HasPrefix(target, "../") {
				// Resolve to absolute path and create symlink to that
				absTarget, err := filepath.EvalSymlinks(fn)
				if err != nil {
					return fmt.Errorf("failed to resolve symlink %s: %w", fn, err)
				}
				if err := os.Symlink(absTarget, outPath); err != nil {
					return fmt.Errorf("failed to create symlink %s -> %s: %w", outPath, absTarget, err)
				}
			} else {
				// Copy symlink as-is
				// NB: the original bash implementation used `cp -pd $fn $out/`
				// to copy the original symlink file and preserve the original target,
				// we instead create a new symlink here to the already resolved target.
				// This should lead to the same result.
				if err := os.Symlink(target, outPath); err != nil {
					return fmt.Errorf("failed to copy symlink %s: %w", fn, err)
				}
			}
		} else {
			// Regular file/directory - create symlink to it
			if err := os.Symlink(fn, outPath); err != nil {
				return fmt.Errorf("failed to symlink %s: %w", fn, err)
			}
		}
	}
	return nil
}

// Phase 2: Copy .wants links
func copyUpstreamWants(cfg Config) error {
	for _, wantName := range cfg.UpstreamWants {
		wantDir := filepath.Join(cfg.PackageSource, "example/systemd", cfg.TypeDir, wantName)

		logDebug("Processing upstream want: %s", wantDir)

		// Check if directory exists
		if _, err := os.Stat(wantDir); err != nil {
			return fmt.Errorf("missing %s: %w", wantDir, err)
		}

		outWantDir := filepath.Join(cfg.OutDir, filepath.Base(wantDir))
		if err := os.Mkdir(outWantDir, 0755); err != nil {
			return fmt.Errorf("failed to create directory %s: %w", outWantDir, err)
		}

		// Iterate over files in the .wants directory
		entries, err := os.ReadDir(wantDir)
		if err != nil {
			return fmt.Errorf("failed to read directory %s: %w", wantDir, err)
		}

		for _, entry := range entries {
			srcLinkPath := filepath.Join(wantDir, entry.Name())
			dstLinkPath := filepath.Join(outWantDir, entry.Name())

			// Check if it's a symlink
			info, err := os.Lstat(srcLinkPath)
			if err != nil {
				return fmt.Errorf("failed to stat %s: %w", srcLinkPath, err)
			}

			if info.Mode()&os.ModeSymlink != 0 {
				// It's a symlink - copy it
				target, err := os.Readlink(srcLinkPath)
				if err != nil {
					return fmt.Errorf("failed to read symlink %s: %w", srcLinkPath, err)
				}

				if err := os.Symlink(target, dstLinkPath); err != nil {
					return fmt.Errorf("failed to copy symlink %s: %w", srcLinkPath, err)
				}

				// Check if target exists, if not remove the symlink (prevent dangling unit links)
				if _, err := os.Stat(dstLinkPath); err != nil {
					os.Remove(dstLinkPath)
				}
			} else {
				// It's a regular file - copy it (matching bash `cp -pd` behavior)
				srcFile, err := os.Open(srcLinkPath)
				if err != nil {
					return fmt.Errorf("failed to open %s: %w", srcLinkPath, err)
				}
				defer srcFile.Close()

				dstFile, err := os.Create(dstLinkPath)
				if err != nil {
					srcFile.Close()
					return fmt.Errorf("failed to create %s: %w", dstLinkPath, err)
				}
				defer dstFile.Close()

				if _, err := io.Copy(dstFile, srcFile); err != nil {
					return fmt.Errorf("failed to copy %s: %w", srcLinkPath, err)
				}

				// Preserve permissions
				if err := os.Chmod(dstLinkPath, info.Mode()); err != nil {
					return fmt.Errorf("failed to chmod %s: %w", dstLinkPath, err)
				}
			}
		}
	}
	return nil
}

// Phase 3: Symlink all units provided in systemd.packages
func symlinkPackages(cfg Config) error {
	// Deduplicate packages
	uniquePkgs := make(map[string]bool)
	for _, pkg := range cfg.Packages {
		uniquePkgs[pkg] = true
	}

	for pkg := range uniquePkgs {
		logDebug("Processing package: %s", pkg)

		// Check both etc/systemd and lib/systemd directories
		dirs := []string{
			filepath.Join(pkg, "etc/systemd", cfg.TypeDir),
			filepath.Join(pkg, "lib/systemd", cfg.TypeDir),
		}

		for _, dir := range dirs {
			entries, err := os.ReadDir(dir)
			if err != nil {
				// Directory might not exist, skip
				continue
			}

			for _, entry := range entries {
				fn := filepath.Join(dir, entry.Name())

				// Skip .wants directories
				if strings.HasSuffix(entry.Name(), ".wants") {
					continue
				}

				if entry.IsDir() {
					// Use lndir for directories
					targetDir := filepath.Join(cfg.OutDir, entry.Name())
					if err := os.MkdirAll(targetDir, 0755); err != nil {
						return fmt.Errorf("failed to create directory %s: %w", targetDir, err)
					}
					if err := lndir(fn, targetDir); err != nil {
						return fmt.Errorf("lndir failed for %s: %w", fn, err)
					}
				} else {
					// Symlink file
					outPath := filepath.Join(cfg.OutDir, entry.Name())
					if err := os.Symlink(fn, outPath); err != nil && !os.IsExist(err) {
						return fmt.Errorf("failed to symlink %s: %w", fn, err)
					}
				}
			}
		}
	}
	return nil
}

// Phase 4: Handle units with asDropinIfExists strategy
// Symlink units defined by systemd.units where override strategy
// shall be automatically detected. If these are also provided by
// systemd or systemd.packages, then add them as
// <unit-name>.d/overrides.conf, which makes them extend the
// upstream unit.
func handleUnitsAutodetect(cfg Config) error {
	for _, unitPath := range cfg.UnitsAutodetect {
		logDebug("Processing autodetect unit: %s", unitPath)

		// Get unit filename (basename of first file in the directory)
		// Note: The bash version uses the horrible glob `basename $i/*` which:
		// - If 0 files: basename errors "missing operand"
		// - If 1 file: works correctly
		// - If 2 files: uses first as NAME and second as SUFFIX (wrong!)
		// - If 3+ files: basename errors "extra operand"
		// We replicate the intent (process first file) but warn if multiple files exist.
		entries, err := os.ReadDir(unitPath)
		if err != nil {
			return fmt.Errorf("failed to read unit directory %s: %w", unitPath, err)
		}
		if len(entries) == 0 {
			continue
		}

		// Warn if multiple files in directory
		if len(entries) > 1 {
			fmt.Fprintf(os.Stderr, "Warning: unit directory %s contains %d files, only processing first: %s\n",
				unitPath, len(entries), entries[0].Name())
		}

		fn := entries[0].Name()
		outPath := filepath.Join(cfg.OutDir, fn)
		unitFile := filepath.Join(unitPath, fn)

		// Check if unit already exists in output
		if _, err := os.Lstat(outPath); err == nil {
			// Unit exists - check if it's /dev/null
			target, err := filepath.EvalSymlinks(unitFile)
			if err != nil {
				return fmt.Errorf("failed to resolve %s: %w", unitFile, err)
			}

			if target == "/dev/null" {
				// Remove existing and link to /dev/null
				os.Remove(outPath)
				if err := os.Symlink("/dev/null", outPath); err != nil {
					return fmt.Errorf("failed to symlink to /dev/null: %w", err)
				}
			} else {
				if cfg.AllowCollisions {
					// Create drop-in directory
					dropinDir := filepath.Join(cfg.OutDir, fn+".d")
					if err := os.MkdirAll(dropinDir, 0755); err != nil {
						return fmt.Errorf("failed to create dropin dir %s: %w", dropinDir, err)
					}
					overrideConf := filepath.Join(dropinDir, "overrides.conf")
					if err := os.Symlink(unitFile, overrideConf); err != nil && !os.IsExist(err) {
						return fmt.Errorf("failed to create override: %w", err)
					}
				} else {
					return fmt.Errorf("Found multiple derivations configuring %s!", fn)
				}
			}
		} else {
			// Unit doesn't exist - create symlink
			if err := os.Symlink(unitFile, outPath); err != nil {
				return fmt.Errorf("failed to symlink unit %s: %w", fn, err)
			}
		}
	}
	return nil
}

// Phase 5: Handle units with asDropin strategy
func handleUnitsDropin(cfg Config) error {
	for _, unitPath := range cfg.UnitsDropin {
		logDebug("Processing dropin unit: %s", unitPath)

		// Get unit filename
		entries, err := os.ReadDir(unitPath)
		if err != nil {
			return fmt.Errorf("failed to read unit directory %s: %w", unitPath, err)
		}
		if len(entries) == 0 {
			continue
		}

		// Warn if multiple files in directory
		// Note: Same basename quirk as in handleUnitsAutodetect - see comment there.
		if len(entries) > 1 {
			fmt.Fprintf(os.Stderr, "Warning: dropin directory %s contains %d files, only processing first: %s\n",
				unitPath, len(entries), entries[0].Name())
		}

		fn := entries[0].Name()
		unitFile := filepath.Join(unitPath, fn)

		// Create drop-in directory
		dropinDir := filepath.Join(cfg.OutDir, fn+".d")
		if err := os.MkdirAll(dropinDir, 0755); err != nil {
			return fmt.Errorf("failed to create dropin dir %s: %w", dropinDir, err)
		}

		// Create overrides.conf symlink
		overrideConf := filepath.Join(dropinDir, "overrides.conf")
		if err := os.Symlink(unitFile, overrideConf); err != nil && !os.IsExist(err) {
			return fmt.Errorf("failed to create override: %w", err)
		}
	}
	return nil
}

// Phase 6: Create service aliases
func createAliases(cfg Config) error {
	for unitName, aliases := range cfg.Aliases {
		for _, alias := range aliases {
			logDebug("Creating alias: %s -> %s", alias, unitName)

			outPath := filepath.Join(cfg.OutDir, alias)
			// Remove existing symlink if present
			os.Remove(outPath)
			if err := os.Symlink(unitName, outPath); err != nil {
				return fmt.Errorf("failed to create alias %s -> %s: %w", alias, unitName, err)
			}
		}
	}
	return nil
}

// Phase 7: Create .wants/.upholds/.requires symlinks
func createDependencies(cfg Config) error {
	// Handle .wants
	for unitName, targets := range cfg.WantedBy {
		for _, target := range targets {
			logDebug("Creating .wants: %s.wants/%s", target, unitName)

			wantsDir := filepath.Join(cfg.OutDir, target+".wants")
			if err := os.MkdirAll(wantsDir, 0755); err != nil {
				return fmt.Errorf("failed to create .wants dir: %w", err)
			}

			linkPath := filepath.Join(wantsDir, unitName)
			linkTarget := "../" + unitName
			os.Remove(linkPath)
			if err := os.Symlink(linkTarget, linkPath); err != nil {
				return fmt.Errorf("failed to create .wants symlink: %w", err)
			}
		}
	}

	// Handle .upholds
	for unitName, targets := range cfg.UpheldBy {
		for _, target := range targets {
			logDebug("Creating .upholds: %s.upholds/%s", target, unitName)

			upholdsDir := filepath.Join(cfg.OutDir, target+".upholds")
			if err := os.MkdirAll(upholdsDir, 0755); err != nil {
				return fmt.Errorf("failed to create .upholds dir: %w", err)
			}

			linkPath := filepath.Join(upholdsDir, unitName)
			linkTarget := "../" + unitName
			os.Remove(linkPath)
			if err := os.Symlink(linkTarget, linkPath); err != nil {
				return fmt.Errorf("failed to create .upholds symlink: %w", err)
			}
		}
	}

	// Handle .requires
	for unitName, targets := range cfg.RequiredBy {
		for _, target := range targets {
			logDebug("Creating .requires: %s.requires/%s", target, unitName)

			requiresDir := filepath.Join(cfg.OutDir, target+".requires")
			if err := os.MkdirAll(requiresDir, 0755); err != nil {
				return fmt.Errorf("failed to create .requires dir: %w", err)
			}

			linkPath := filepath.Join(requiresDir, unitName)
			linkTarget := "../" + unitName
			os.Remove(linkPath)
			if err := os.Symlink(linkTarget, linkPath); err != nil {
				return fmt.Errorf("failed to create .requires symlink: %w", err)
			}
		}
	}

	return nil
}

// Phase 8: Create system-specific symlinks
func createSystemSymlinks(cfg Config) error {
	// Note: The bash version uses `ln -s` without -f, so we don't remove existing files first.
	// This will fail if the files already exist, matching bash behavior.
	if cfg.DefaultUnit != "" {
		logDebug("Creating default.target -> %s", cfg.DefaultUnit)
		outPath := filepath.Join(cfg.OutDir, "default.target")
		if err := os.Symlink(cfg.DefaultUnit, outPath); err != nil {
			return fmt.Errorf("failed to create default.target: %w", err)
		}
	}

	if cfg.CtrlAltDelUnit != "" {
		logDebug("Creating ctrl-alt-del.target -> %s", cfg.CtrlAltDelUnit)
		outPath := filepath.Join(cfg.OutDir, "ctrl-alt-del.target")
		if err := os.Symlink(cfg.CtrlAltDelUnit, outPath); err != nil {
			return fmt.Errorf("failed to create ctrl-alt-del.target: %w", err)
		}
	}

	// Create multi-user.target.wants/remote-fs.target
	wantsDir := filepath.Join(cfg.OutDir, "multi-user.target.wants")
	if err := os.MkdirAll(wantsDir, 0755); err != nil {
		return fmt.Errorf("failed to create multi-user.target.wants: %w", err)
	}
	linkPath := filepath.Join(wantsDir, "remote-fs.target")
	if err := os.Symlink("../remote-fs.target", linkPath); err != nil {
		return fmt.Errorf("failed to create remote-fs.target link: %w", err)
	}

	return nil
}

// lndir implements the xorg lndir functionality natively in Go
// Recursively creates recreates directories, and symlinks files from src to dst
func lndir(src, dst string) error {
	return filepath.Walk(src, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		// Skip the root directory itself
		if path == src {
			return nil
		}

		relPath, err := filepath.Rel(src, path)
		if err != nil {
			return err
		}

		dstPath := filepath.Join(dst, relPath)

		if info.IsDir() {
			return os.MkdirAll(dstPath, 0755)
		}

		// Create symlink to the source file
		return os.Symlink(path, dstPath)
	})
}
