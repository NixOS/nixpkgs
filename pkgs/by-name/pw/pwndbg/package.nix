{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPypi,
  python3,
  gdb,
  cmake,
  makeBinaryWrapper,
}:

let
  python = python3;

  # gdb-pt-dump, published as the `pt` distribution. pwndbg hard-imports it at load time
  # (pwndbg.aglib.qemu) to walk page tables of qemu-system targets. upstream pins an exact
  # git rev; nixpkgs has no `pt`, so we fetch that rev and build the poetry package.
  pt = python.pkgs.buildPythonPackage {
    pname = "pt";
    version = "1.0.0-unstable-2024-04-01";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "martinradev";
      repo = "gdb-pt-dump";
      rev = "50227bda0b6332e94027f811a15879588de6d5cb";
      hash = "sha256-yiP3KY1oDwhy9DmNQEht/ryys9vpgkFS+EJcSA6R+cI=";
    };

    build-system = [ python.pkgs.poetry-core ];

    pythonImportsCheck = [ "pt" ];

    meta = {
      description = "GDB script to examine the address space of a QEMU-based virtual machine";
      homepage = "https://github.com/martinradev/gdb-pt-dump";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  };

  # pwndbg 2026.x hard-imports `capstone6pwndbg`, the upstream capstone v6 alpha fork
  # republished under this distribution name. nixpkgs' `capstone` is 5.x and imports as
  # `capstone`, so it cannot satisfy the import; we build the v6 sdist, whose setup.py
  # drives cmake to compile the bundled C engine.
  capstone6pwndbg = python.pkgs.buildPythonPackage rec {
    pname = "capstone6pwndbg";
    version = "6.0.0a9";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-2GWuaZQN2hpZVGDc2yUOZlK2magN/c8vC49AwIZF2FM=";
    };

    build-system = with python.pkgs; [
      setuptools
      wheel
    ];

    # setup.py invokes cmake itself; do not let the cmake setup-hook take over configure.
    nativeBuildInputs = [ cmake ];
    dontUseCmakeConfigure = true;

    pythonImportsCheck = [ "capstone6pwndbg" ];
    doCheck = false;

    meta = {
      description = "Capstone v6 disassembly engine bindings pinned by pwndbg";
      homepage = "https://www.capstone-engine.org";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.linux;
    };
  };

  # niche-elf is a small pure-python ELF helper hard-imported by pwndbg's decompiler
  # integration and `klookup` command; not otherwise in nixpkgs.
  niche-elf = python.pkgs.buildPythonPackage rec {
    pname = "niche-elf";
    version = "0.3.6";
    pyproject = true;

    src = fetchPypi {
      pname = "niche_elf";
      inherit version;
      hash = "sha256-pPbmi15rwGmhTwh7zBmUEaWYNT1soFAkhVHxErtVZeU=";
    };

    build-system = [ python.pkgs.setuptools ];

    pythonImportsCheck = [ "niche_elf" ];

    meta = {
      description = "Small library optimizing niche ELF operations for debugger extensions";
      homepage = "https://pypi.org/project/niche-elf/";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux;
    };
  };

  pwndbgLib = python.pkgs.buildPythonPackage rec {
    pname = "pwndbg";
    version = "2026.07.29";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "pwndbg";
      repo = "pwndbg";
      tag = version;
      hash = "sha256-OkUJtFFvJ00/Ai7DsGqg+KA91Vt+17weJX/hrw0c03c=";
    };

    build-system = [ python.pkgs.hatchling ];

    # upstream pins a bundled gdb wheel, uv, and several optional-command deps that either
    # do not belong in a nix build or are not in nixpkgs. gdb comes from the wrapper below;
    # the rest gate optional commands and pwndbg degrades gracefully without them.
    pythonRemoveDeps = [
      "capstone6pwndbg"
      "gdb-for-pwndbg"
      "lldb-for-pwndbg"
      "uv"
      "pt"
      "ziglang"
      "decomp2dbg"
      "jpype1"
    ];

    dependencies = with python.pkgs; [
      capstone6pwndbg
      niche-elf
      pt
      unicorn
      pwntools
      sortedcontainers
      tabulate
      typing-extensions
      pycparser
      pyelftools
      pygments
      psutil
      requests
      rich
      ipython
      ropgadget
    ];

    # runtime deps are looser than nixpkgs' pins in a few spots (rich, pyelftools); the
    # loaded feature set does not need the newest APIs, so skip the strict version gate.
    dontCheckRuntimeDeps = true;

    # importing the `pwndbg` package requires a live gdb host, so it cannot run standalone.
    pythonImportsCheck = [ ];
    doCheck = false;

    meta = {
      description = "Exploit development and reverse engineering with GDB made easy";
      homepage = "https://github.com/pwndbg/pwndbg";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  };

  pythonEnv = python.withPackages (_: [ pwndbgLib ]);
in
stdenv.mkDerivation {
  pname = "pwndbg";
  inherit (pwndbgLib) version;

  dontUnpack = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    # gdbinit.py ships as shared-data at share/pwndbg/gdbinit.py; with no `.pwndbg_root`
    # sentinel beside it, pwndbg treats this as a system install, skips its venv bootstrap,
    # and loads straight off PYTHONPATH.
    makeWrapper ${gdb}/bin/gdb $out/bin/pwndbg \
      --add-flags "--nx --quiet --command=${pythonEnv}/share/pwndbg/gdbinit.py" \
      --set NIX_PYTHONPATH ${pythonEnv}/${python.sitePackages} \
      --set PYTHONPATH ${pythonEnv}/${python.sitePackages} \
      --prefix PATH : ${lib.makeBinPath [ pythonEnv ]}

    runHook postInstall
  '';

  meta = {
    description = "Exploit development and reverse engineering with GDB made easy";
    longDescription = ''
      pwndbg is a GDB plug-in that eases exploitation and reverse engineering: a
      compact register/stack/disassembly context, heap inspection, ROP tooling, and
      emulation, aimed at low-level debugging workflows.
    '';
    homepage = "https://github.com/pwndbg/pwndbg";
    changelog = "https://github.com/pwndbg/pwndbg/releases/tag/${pwndbgLib.version}";
    license = lib.licenses.mit;
    mainProgram = "pwndbg";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ vmfunc ];
  };
}
