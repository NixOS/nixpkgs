# Love2D macOS/Darwin Support for nixpkgs - Contribution Analysis

## 🗑️ TODO: Remove this file before pushing final commits
This file is for development tracking and should be deleted before the final PR submission.

## 📝 PR Text Base
This file can be used as reference material for writing the PR description and commit messages.

## 🚀 **Progress Status**
- ✅ **Repo cloned and ready**
- ✅ **Branch created**: `love2d-darwin-support` (renamed from love2d-darwin-fixes)  
- ✅ **Analysis documented and committed**
- ⏳ **Next**: Locate and examine current Love2D package definition

## Assessment: Contributing Love2D macOS Support to nixpkgs

**TL;DR: This is a VERY viable and valuable contribution!** Here's why:

### 🎯 **Current Situation**
- **Love2D IS available in nixpkgs** but **ONLY for Linux platforms**
- **There's an active GitHub issue** ([#369476](https://github.com/NixOS/nixpkgs/issues/369476)) requesting Love2D for Darwin (created Dec 30, 2024)
- The current nixpkgs definition explicitly sets `platforms = lib.platforms.linux;`

#### Related GitHub Issue Summary

**Issue #369476: "Package request: `love` for darwin"**
- **Created**: December 30, 2024 (very recent!)
- **Status**: Open
- **Community Interest**: 1 👍 reaction, 2 comments
- **Current Maintainer Response**: @7c6f434c (current maintainer) acknowledged they are "absolutely useless on Darwin" but willing to "review and merge specific Darwin fixes"

**Key Issue Details**:
- Author noted Love2D is already packaged for Linux only
- Provided direct link to current package definition
- Requested Darwin platform support
- Issue follows proper nixpkgs package request format

**Maintainer Feedback**:
- Current maintainer (@7c6f434c) admits limited Darwin expertise
- **Explicitly open to reviewing and merging Darwin fixes** 
- Acknowledges GUI needs make "hope for POSIX" unreliable
- **This is very encouraging** - maintainer is receptive to community contributions

**Strategic Advantage**: The timing is perfect - this is a fresh request with an interested maintainer who has explicitly stated willingness to review Darwin fixes. Your contribution would directly address a recent community need!

### 💪 **Why This is Viable**

1. **Love2D officially supports macOS**:
   - The upstream project has native macOS support
   - Has dedicated platform-specific code (`src/common/apple.mm`, Metal graphics backend, etc.)
   - Provides Xcode projects and prebuilt `.app` bundles

2. **The packaging work needed is minimal**:
   - The existing Nix derivation is well-structured
   - Main changes needed:
     - Replace Linux-specific dependencies with macOS equivalents
     - Update `platforms = lib.platforms.linux;` → `lib.platforms.darwin;` (or both)
     - Handle framework linking (`-framework CoreFoundation`, `-framework IOKit`, etc.)

3. **Dependencies are mostly available**:
   - SDL2: ✅ Available on Darwin
   - OpenAL: ✅ Available 
   - LuaJIT: ✅ Available (though Love2D recommends regular Lua on macOS)
   - Most other deps: ✅ Available

### 🔧 **Technical Approach**

The contribution would involve:

1. **Modify the existing derivation** in `pkgs/development/interpreters/love/11.nix`:
   ```nix
   # Instead of Linux-specific packages
   buildInputs = [
     SDL2
   ] ++ lib.optionals stdenv.isLinux [
     xorg.libX11 libGLU libGL
   ] ++ lib.optionals stdenv.isDarwin [
     darwin.apple_sdk.frameworks.Cocoa
     darwin.apple_sdk.frameworks.OpenGL
     darwin.apple_sdk.frameworks.CoreFoundation
     darwin.apple_sdk.frameworks.IOKit
   ] ++ [
     # Common deps...
   ];
   ```

2. **Update platform support**:
   ```nix
   platforms = lib.platforms.linux ++ lib.platforms.darwin;
   ```

3. **Handle build differences**:
   - macOS might need different configure flags
   - Framework linking instead of direct library linking

### 🌟 **Why This is Valuable**

1. **High impact**: Love2D is widely used for game development
2. **Recent demand**: The GitHub issue was just created 2 weeks ago
3. **Educational value**: You'd learn about:
   - Cross-platform Nix packaging
   - macOS framework handling in Nix
   - Contributing to major open source projects
4. **Community benefit**: Many macOS + Nix users would benefit

### 📋 **Detailed Contribution Steps**

#### 1. **Fork and Setup nixpkgs Repository** ✅ **DONE**
```bash
# ✅ Fork https://github.com/NixOS/nixpkgs on GitHub - DONE
# ✅ git clone https://github.com/DannyDannyDanny/nixpkgs.git - DONE
# ✅ cd nixpkgs - DONE
# ✅ git remote add upstream https://github.com/NixOS/nixpkgs.git - DONE

# ✅ Create a feature branch - DONE
# git checkout -b love2d-darwin-support
```

#### 2. **Locate and Understand the Current Package**
```bash
# The Love2D package is located at:
# pkgs/development/interpreters/love/11.nix
# Also check: pkgs/development/interpreters/love/default.nix

# Study the current implementation
cat pkgs/development/interpreters/love/11.nix
```

#### 3. **Set Up Local Testing Environment**
```bash
# Test building the current (Linux-only) version to understand the process
# This will fail on macOS, but shows you the build process
nix-build -A love

# Enable building unsupported packages for testing
export NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1
nix-build -A love --impure
```

#### 4. **Modify the Love2D Derivation**

Edit `pkgs/development/interpreters/love/11.nix`:

**Key changes needed:**
- Add Darwin-specific dependencies (frameworks)
- Make buildInputs conditional based on platform
- Update platforms list
- Possibly adjust build process for macOS

**Example modifications:**
```nix
# Add to function arguments
{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  SDL2,
  libGLU,
  libGL,
  openal,
  luajit,
  lua5_1,  # Add regular Lua as alternative to LuaJIT
  libdevil,
  freetype,
  physfs,
  libmodplug,
  mpg123,
  libvorbis,
  libogg,
  libtheora,
  which,
  autoconf,
  automake,
  libtool,
  xorg,
  # Add Darwin-specific inputs
  darwin,
}:

# In buildInputs, make it conditional:
buildInputs = [
  SDL2
  openal
  (if stdenv.isDarwin then lua5_1 else luajit)  # Use Lua instead of LuaJIT on macOS
  libdevil
  freetype
  physfs
  libmodplug
  mpg123
  libvorbis
  libogg
  libtheora
  which
  libtool
] ++ lib.optionals stdenv.isLinux [
  xorg.libX11
  libGLU
  libGL
] ++ lib.optionals stdenv.isDarwin [
  darwin.apple_sdk.frameworks.Cocoa
  darwin.apple_sdk.frameworks.OpenGL
  darwin.apple_sdk.frameworks.CoreFoundation
  darwin.apple_sdk.frameworks.IOKit
];

# Update configureFlags conditionally
configureFlags = [
  (if stdenv.isDarwin then "--with-lua=lua" else "--with-lua=luajit")
];

# Update platforms
meta = {
  homepage = "https://love2d.org";
  description = "Lua-based 2D game engine/scripting language";
  mainProgram = "love";
  license = lib.licenses.zlib;
  platforms = lib.platforms.linux ++ lib.platforms.darwin;  # Add Darwin support
  maintainers = [ lib.maintainers.raskin ];
};
```

#### 5. **Test the Build Locally**
```bash
# Try building your modified version
nix-build -A love

# If successful, test installation
nix-env -f . -iA love

# Create a simple test Love2D project
mkdir love_test
cd love_test
cat > main.lua << EOF
function love.draw()
    love.graphics.print("Hello World", 400, 300)
end
EOF

# Test running it
love .
```

#### 6. **Run nixpkgs Tests**
```bash
# Check if your changes break anything
nix-build -A love.tests  # if tests exist

# Run other relevant tests
nix-build -A tests.cross  # cross-compilation tests
```

#### 7. **Create Comprehensive Test Plan**

Test your implementation with:
- Simple "Hello World" Love2D app
- Love2D app that uses graphics, audio, input
- Love2D app from the wild (e.g., from itch.io)

#### 8. **Follow nixpkgs Testing Requirements**

**Run nixpkgs-review** (official requirement):
```bash
# Install nixpkgs-review if not already available
nix-shell -p nixpkgs-review

# Test your changes (builds and tests affected packages)
nixpkgs-review wip
```

**Test on required platforms** (from PR template checklist):
- [x] aarch64-darwin (your system)
- [ ] x86_64-darwin (if available, or note in PR you couldn't test)

**Test basic functionality**:
- [ ] All binary files work (check `./result/bin/`)
- [ ] Package actually runs Love2D games correctly

#### 9. **Commit Using Official nixpkgs Format**

**Commit message must follow nixpkgs conventions:**
```bash
git add pkgs/development/interpreters/love/11.nix

# Official format: (pkg-name): (change description)
git commit -m "love2d: add Darwin platform support

- Add conditional Darwin dependencies (Cocoa, OpenGL frameworks)  
- Use Lua instead of LuaJIT on macOS (upstream recommendation)
- Update platforms to include Darwin
- Add conditional build inputs for Linux vs Darwin

Fixes #369476"

git push origin love2d-darwin-support
```

**Important**: The `love2d:` prefix is required - it triggers automatic CI builds!

#### 10. **Submit Pull Request Using Official Template**

**PR Title:** `love2d: add Darwin platform support`

**Use the official nixpkgs PR template** (fill out completely):

```markdown
## Description
Adds macOS/Darwin support to the Love2D package, enabling Love2D game development on nix-darwin systems.

## Changes  
- Added conditional Darwin dependencies (Cocoa, OpenGL frameworks)
- Use Lua instead of LuaJIT on macOS (following upstream recommendations)
- Updated platforms list to include Darwin  
- Made buildInputs conditional for Linux vs Darwin

Closes #369476

## Things done

<!-- Official nixpkgs PR template checklist: -->

- Built on platform:
  - [ ] x86_64-linux
  - [ ] aarch64-linux  
  - [ ] x86_64-darwin
  - [x] aarch64-darwin
- Tested, as applicable:
  - [ ] NixOS tests in nixos/tests.
  - [ ] Package tests at `passthru.tests`.
  - [ ] Tests in lib/tests or pkgs/test for functions and "core" functionality.
- [x] Ran `nixpkgs-review` on this PR.
- [x] Tested basic functionality of all binary files, usually in `./result/bin/`.
- Nixpkgs Release Notes
  - [ ] Package update: when the change is major or breaking.
- NixOS Release Notes
  - [ ] Module addition: when adding a new NixOS module.
  - [ ] Module update: when the change is significant.
- [x] Fits CONTRIBUTING.md, pkgs/README.md, maintainers/README.md and other READMEs.

## Testing Details
- [x] Built successfully on aarch64-darwin  
- [x] Tested with simple Love2D "Hello World" application
- [x] Verified Love2D functionality (graphics, audio, input)
- [x] Confirmed `love --version` works correctly
- [ ] Cross-platform testing (x86_64-darwin) - **Need help from reviewers**

Note: I only have access to aarch64-darwin for testing. Would appreciate cross-platform testing help from maintainers with x86_64-darwin systems.
```

#### 11. **Work with Maintainers**
- Respond to review feedback promptly
- Be prepared to make adjustments based on:
  - Build system preferences
  - Dependency choices
  - Testing requirements
  - Code style
- Test on different macOS versions if requested

### 🎯 **Success Probability: HIGH**

- Clear community need (open GitHub issue)
- Upstream supports macOS natively  
- Most dependencies already available on Darwin
- Well-defined scope of work
- Active maintainer (lib.maintainers.raskin)

**This would be an excellent first nixpkgs contribution!** The scope is manageable, there's clear demand, and you'd be solving a real problem for the Nix + macOS community.

## Current Love2D Package Definition

Here's the current Linux-only definition from nixpkgs:

```nix
{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  SDL2,
  libGLU,
  libGL,
  openal,
  luajit,
  libdevil,
  freetype,
  physfs,
  libmodplug,
  mpg123,
  libvorbis,
  libogg,
  libtheora,
  which,
  autoconf,
  automake,
  libtool,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "love";
  version = "11.5";

  src = fetchFromGitHub {
    owner = "love2d";
    repo = "love";
    rev = version;
    sha256 = "sha256-wZktNh4UB3QH2wAIIlnYUlNoXbjEDwUmPnT4vesZNm0=";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
  ];
  
  buildInputs = [
    SDL2
    xorg.libX11 # SDl2 optional depend, for SDL_syswm.h
    libGLU
    libGL
    openal
    luajit
    libdevil
    freetype
    physfs
    libmodplug
    mpg123
    libvorbis
    libogg
    libtheora
    which
    libtool
  ];

  preConfigure = "$shell ./platform/unix/automagic";

  configureFlags = [
    "--with-lua=luajit"
  ];

  env.NIX_CFLAGS_COMPILE = "-DluaL_reg=luaL_Reg"; # needed since luajit-2.1.0-beta3

  meta = {
    homepage = "https://love2d.org";
    description = "Lua-based 2D game engine/scripting language";
    mainProgram = "love";
    license = lib.licenses.zlib;
    platforms = lib.platforms.linux;  # ← This is what needs to change!
    maintainers = [ lib.maintainers.raskin ];
  };
}
```

## Key Issues Found

1. **Platform restriction**: `platforms = lib.platforms.linux;`
2. **Linux-specific dependencies**: `xorg.libX11`, `libGLU`, `libGL` 
3. **Build process**: Uses `./platform/unix/automagic` which may not work on macOS
4. **LuaJIT usage**: Love2D upstream recommends regular Lua on macOS instead of LuaJIT

## Next Steps

If you want to proceed with this contribution, the next step would be to:

1. Fork the nixpkgs repository
2. Create a local test environment 
3. Start modifying the Love2D derivation to support Darwin
4. Test the build and functionality on your macOS system

This would be a valuable contribution to the Nix ecosystem!

## Official nixpkgs Contribution Requirements

Based on the official nixpkgs documentation, here are the key requirements you must follow:

### 🔧 **Technical Requirements**

1. **Commit Message Format** (from `pkgs/README.md`):
   ```
   (pkg-name): (from -> to | init at version | refactor | etc)
   
   (Motivation for change. Link to release notes. Additional information.)
   ```
   - The `love2d:` prefix is **required** - it triggers automatic CI builds
   - Examples: `love2d: add Darwin platform support`, `nginx: 1.0 -> 2.0`

2. **nixpkgs-review** (official requirement):
   - **Must run** `nixpkgs-review wip` before submitting
   - This tests your changes and all affected packages
   - Install with: `nix-shell -p nixpkgs-review`

3. **Platform Testing** (from PR template):
   - Must test on the platforms you're adding support for
   - Mark which platforms you've tested in the PR checklist
   - Ask for help testing other platforms if you don't have access

### 📋 **Official PR Template Checklist**

The nixpkgs PR template includes these required items:

- **Built on platform**: Check boxes for platforms tested
- **Tested basic functionality**: Confirm binaries work 
- **Ran nixpkgs-review**: Must be checked
- **Fits contribution guidelines**: Must follow CONTRIBUTING.md, pkgs/README.md

### 🎯 **Code Quality Requirements**

1. **General Code Conventions** (from CONTRIBUTING.md):
   - Follow both general and package-specific conventions
   - Test changes thoroughly
   - Document changes when necessary

2. **Package-Specific Requirements**:
   - Use conditional dependencies properly (`lib.optionals`)
   - Handle platform differences cleanly
   - Maintain backward compatibility for existing Linux users

### ✅ **Review Process**

- Comments are non-blocking by default
- Blocking comments use "Request Changes" review type  
- Respond to feedback promptly
- Keep PR in mergeable state
- Be available for discussion and re-review

### 🚨 **Critical Points**

1. **nixpkgs-review is mandatory** - don't skip this step
2. **Commit message prefix matters** - triggers CI builds
3. **PR template must be filled out completely** - it's not optional
4. **Test thoroughly** - broken packages affect the entire ecosystem

These are the official requirements from nixpkgs maintainers, not just suggestions!
