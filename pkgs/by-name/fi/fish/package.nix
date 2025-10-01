{
  stdenv,
  lib,
  fetchFromGitHub,
  coreutils,
  darwin,
  glibcLocales,
  gnused,
  gnugrep,
  groff,
  gawk,
  man-db,
  ninja,
  getent,
  libiconv,
  pcre2,
  pkg-config,
  sphinx,
  gettext,
  ncurses,
  python3,
  cargo,
  cmake,
  fishPlugins,
  procps,
  rustc,
  rustPlatform,
  versionCheckHook,
  writableTmpDirAsHomeHook,

  # used to generate autocompletions from manpages and for configuration editing in the browser
  usePython ? true,

  runCommand,
  writeText,
  nixosTests,
  nix-update-script,
  useOperatingSystemEtc ? true,
  # An optional string containing Fish code that initializes the environment.
  # This is run at the very beginning of initialization. If it sets $NIX_PROFILES
  # then Fish will use that to configure its function, completion, and conf.d paths.
  # For example:
  #   fishEnvPreInit = "source /etc/fish/my-env-preinit.fish";
  # It can also be a function that takes one argument, which is a function that
  # takes a path to a bash file and converts it to fish. For example:
  #   fishEnvPreInit = source: source "${nix}/etc/profile.d/nix-daemon.sh";
  fishEnvPreInit ? null,
}:
let
  etcConfigAppendix = writeText "config.fish.appendix" ''
    ############### ↓ Nix hook for sourcing /etc/fish/config.fish ↓ ###############
    #                                                                             #
    # Origin:
    #     This fish package was called with the attribute
    #     "useOperatingSystemEtc = true;".
    #
    # Purpose:
    #     Fish ordinarily sources /etc/fish/config.fish as
    #        $__fish_sysconfdir/config.fish,
    #     and $__fish_sysconfdir is defined at compile-time, baked into the C++
    #     component of fish. By default, it is set to "/etc/fish". When building
    #     through Nix, $__fish_sysconfdir gets set to $out/etc/fish. Here we may
    #     have included a custom $out/etc/config.fish in the fish package,
    #     as specified, but according to the value of useOperatingSystemEtc, we
    #     may want to further source the real "/etc/fish/config.fish" file.
    #
    #     When this option is enabled, this segment should appear the very end of
    #     "$out/etc/config.fish". This is to emulate the behavior of fish itself
    #     with respect to /etc/fish/config.fish and ~/.config/fish/config.fish:
    #     source both, but source the more global configuration files earlier
    #     than the more local ones, so that more local configurations inherit
    #     from but override the more global locations.
    #
    #     Special care needs to be taken, when fish is called from an FHS user env
    #     or similar setup, because this configuration file will then be relocated
    #     to /etc/fish/config.fish, so we test for this case to avoid nontermination.

    if test -f /etc/fish/config.fish && test /etc/fish/config.fish != (status filename)
      source /etc/fish/config.fish
    end

    #                                                                             #
    ############### ↑ Nix hook for sourcing /etc/fish/config.fish ↑ ###############
  '';

  fishPreInitHooks = writeText "__fish_build_paths_suffix.fish" ''
    # source nixos environment
    # note that this is required:
    #   1. For all shells, not just login shells (mosh needs this as do some other command-line utilities)
    #   2. Before the shell is initialized, so that config snippets can find the commands they use on the PATH
    builtin status is-login
    or test -z "$__fish_nixos_env_preinit_sourced" -a -z "$ETC_PROFILE_SOURCED" -a -z "$ETC_ZSHENV_SOURCED"
    ${
      if fishEnvPreInit != null then
        ''
          and begin
          ${lib.removeSuffix "\n" (
            if lib.isFunction fishEnvPreInit then fishEnvPreInit sourceWithFenv else fishEnvPreInit
          )}
          end''
      else
        ''
          and test -f /etc/fish/nixos-env-preinit.fish
          and source /etc/fish/nixos-env-preinit.fish''
    }
    and set -gx __fish_nixos_env_preinit_sourced 1

    test -n "$NIX_PROFILES"
    and begin
      # We ensure that __extra_* variables are read in $__fish_datadir/config.fish
      # with a preference for user-configured data by making sure the package-specific
      # data comes last. Files are loaded/sourced in encounter order, duplicate
      # basenames get skipped, so we assure this by prepending Nix profile paths
      # (ordered in reverse of the $NIX_PROFILE variable)
      #
      # Note that at this point in evaluation, there is nothing whatsoever on the
      # fish_function_path. That means we don't have most fish builtins, e.g., `eval`.


      # additional profiles are expected in order of precedence, which means the reverse of the
      # NIX_PROFILES variable (same as config.environment.profiles)
      set -l __nix_profile_paths (string split ' ' $NIX_PROFILES)[-1..1]

      set -p __extra_completionsdir \
        $__nix_profile_paths"/etc/fish/completions" \
        $__nix_profile_paths"/share/fish/vendor_completions.d"
      set -p __extra_functionsdir \
        $__nix_profile_paths"/etc/fish/functions" \
        $__nix_profile_paths"/share/fish/vendor_functions.d"
      set -p __extra_confdir \
        $__nix_profile_paths"/etc/fish/conf.d" \
        $__nix_profile_paths"/share/fish/vendor_conf.d"
    end
  '';

  # This is wrapped in begin/end in case the user wants to apply redirections.
  # This does mean the basic usage of sourcing a single file will produce
  # `begin; begin; …; end; end` but that's ok.
  sourceWithFenv = path: ''
    begin # fenv
      # This happens before $__fish_datadir/config.fish sets fish_function_path, so it is currently
      # unset. We set it and then completely erase it, leaving its configuration to $__fish_datadir/config.fish
      set fish_function_path ${fishPlugins.foreign-env}/share/fish/vendor_functions.d $__fish_datadir/functions
      fenv source ${lib.escapeShellArg path}
      set -l fenv_status $status
      # clear fish_function_path so that it will be correctly set when we return to $__fish_datadir/config.fish
      set -e fish_function_path
      test $fenv_status -eq 0
    end # fenv
  '';

in
stdenv.mkDerivation (finalAttrs: {
  pname = "fish";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "fish-shell";
    repo = "fish-shell";
    tag = finalAttrs.version;
    hash = "sha256-3VwDwRjYo9/ifkl2Vt9pTmLabt+XyS0FXi0el+YgC/A=";
  };

  env = {
    FISH_BUILD_VERSION = finalAttrs.version;
    # Skip tests that are known to be flaky in CI
    CI = 1;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src patches;
    hash = "sha256-WZdfon6mnM+5caWW6yInQx5B1GjCxQ0XLbJlbvHa3Zc=";
  };

  patches = [
    # This test fails if the nix sandbox gets created on a filesystem that's
    # mounted with the nosuid option.
    ./disable_suid_test.patch

    # We don’t want to run `/usr/libexec/path_helper` on nix-darwin,
    # as it pulls in paths not tracked in the system configuration
    # and messes up the order of `$PATH`. Upstream are unfortunately
    # unwilling to accept a change for this and have recommended that
    # it should be a distro‐specific patch instead.
    #
    # See:
    #
    # * <https://github.com/LnL7/nix-darwin/issues/122>
    # * <https://github.com/fish-shell/fish-shell/issues/7142>
    ./nix-darwin-path.patch
  ];

  # Fix FHS paths in tests
  postPatch = ''
    substituteInPlace src/builtins/tests/test_tests.rs \
      --replace-fail '"/bin/ls"' '"${lib.getExe' coreutils "ls"}"'

    substituteInPlace src/highlight/tests.rs \
      --replace-fail '"/bin/echo"' '"${lib.getExe' coreutils "echo"}"' \
      --replace-fail '"/bin/c"' '"${lib.getExe' coreutils "c"}"' \
      --replace-fail '"/bin/ca"' '"${lib.getExe' coreutils "ca"}"' \
      --replace-fail '/usr' '/'

    substituteInPlace tests/checks/cd.fish \
      --replace-fail '/bin/pwd' '${lib.getExe' coreutils "pwd"}'

    substituteInPlace tests/checks/redirect.fish \
      --replace-fail '/bin/echo' '${lib.getExe' coreutils "echo"}'

    substituteInPlace tests/checks/vars_as_commands.fish \
      --replace-fail '/usr/bin' '${coreutils}/bin'

    substituteInPlace tests/checks/jobs.fish \
      --replace-fail 'ps -o' '${lib.getExe' procps "ps"} -o' \
      --replace-fail '/bin/echo' '${lib.getExe' coreutils "echo"}'

    substituteInPlace tests/checks/job-control-noninteractive.fish \
      --replace-fail '/bin/echo' '${lib.getExe' coreutils "echo"}'

    substituteInPlace tests/checks/complete.fish \
      --replace-fail '/bin/ls' '${lib.getExe' coreutils "ls"}'

    # Several pexpect tests are flaky
    # See https://github.com/fish-shell/fish-shell/issues/8789
    rm tests/pexpects/exit_handlers.py
    rm tests/pexpects/private_mode.py
    rm tests/pexpects/history.py
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Tests use pkill/pgrep which are currently not built on Darwin
    # See https://github.com/NixOS/nixpkgs/pull/103180
    # and https://github.com/NixOS/nixpkgs/issues/141157
    rm tests/pexpects/exit.py
    rm tests/pexpects/job_summary.py
    rm tests/pexpects/signals.py
    rm tests/pexpects/fg.py
    rm tests/checks/fish_exit.fish
  ''
  + lib.optionalString (stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isDarwin) ''
    # This test seems to consistently fail on aarch64 and darwin
    rm tests/checks/cd.fish
  '';

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cargo
    cmake
    gettext
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    # Avoid warnings when building the manpages about HOME not being writable
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    libiconv
    pcre2
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_DOCDIR" "${placeholder "doc"}/share/doc/fish")
    (lib.cmakeFeature "Rust_CARGO_TARGET" stdenv.hostPlatform.rust.rustcTarget)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeBool "MAC_CODESIGN_ID" false)
  ];

  # Fish’s test suite needs to be able to look up process information and send signals.
  sandboxProfile = lib.optionalString stdenv.hostPlatform.isDarwin ''
    (allow mach-lookup mach-task-name)
    (allow signal (target children))
  '';

  # The optional string is kind of an inelegant way to get fish to cross compile.
  # Fish needs coreutils as a runtime dependency, and it gets put into
  # CMAKE_PREFIX_PATH, which cmake uses to look up build time programs, so it
  # was clobbering the PATH. It probably needs to be fixed at a lower level.
  preConfigure = ''
    patchShebangs ./build_tools/git_version_gen.sh
    patchShebangs ./tests/test_driver.py
  ''
  + lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    export CMAKE_PREFIX_PATH=
  '';

  # Required binaries during execution
  propagatedBuildInputs = [
    coreutils
    gnugrep
    gnused
    groff
    gettext
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) man-db;

  doCheck = true;

  nativeCheckInputs = [
    coreutils
    glibcLocales
    (python3.withPackages (ps: [ ps.pexpect ]))
    procps
    sphinx
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # For the getconf command, used in default-setup-path.fish
    darwin.system_cmds
  ];

  # we target the top-level make target which runs all the cmake/ctest
  # tests, including test_cargo-test
  checkTarget = "fish_run_tests";
  preCheck = ''
    export TERMINFO="${ncurses}/share/terminfo"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  # Ensure that we don't vendor libpcre2, but instead link against the one from nixpkgs
  installCheckPhase = lib.optionalString (stdenv.hostPlatform.libc == "glibc") ''
    runHook preInstallCheck

    echo "Checking that we don't vendor pcre2"
    ldd "$out/bin/fish" | grep ${lib.getLib pcre2}

    runHook postInstallCheck
  '';

  postInstall = ''
    substituteInPlace "$out/share/fish/functions/grep.fish" \
      --replace-fail "command grep" "command ${lib.getExe gnugrep}"

    substituteInPlace "$out/share/fish/functions/__fish_print_help.fish" \
      --replace-fail "nroff" "${lib.getExe' groff "nroff"}"

    substituteInPlace $out/share/fish/completions/{sudo.fish,doas.fish} \
      --replace-fail "/usr/local/sbin /sbin /usr/sbin" ""
  ''
  + lib.optionalString usePython ''
    cat > $out/share/fish/functions/__fish_anypython.fish <<EOF
    function __fish_anypython
        echo ${python3.interpreter}
        return 0
    end
    EOF
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    for cur in $out/share/fish/functions/*.fish; do
      substituteInPlace "$cur" \
        --replace-quiet '/usr/bin/getent' '${lib.getExe getent}' \
        --replace-quiet 'awk' '${lib.getExe' gawk "awk"}'
    done
    for cur in $out/share/fish/completions/*.fish; do
      substituteInPlace "$cur" \
        --replace-quiet 'awk' '${lib.getExe' gawk "awk"}'
    done
  ''
  + lib.optionalString useOperatingSystemEtc ''
    tee -a $out/etc/fish/config.fish < ${etcConfigAppendix}
  ''
  + ''
    tee -a $out/share/fish/__fish_build_paths.fish < ${fishPreInitHooks}
  '';

  meta = {
    description = "Smart and user-friendly command line shell";
    homepage = "https://fishshell.com/";
    changelog = "https://github.com/fish-shell/fish-shell/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      adamcstephens
      cole-h
      winter
      sigmasquadron
      rvdp
    ];
    mainProgram = "fish";
  };

  passthru = {
    shellPath = "/bin/fish";
    tests = {
      nixos = lib.optionalAttrs stdenv.hostPlatform.isLinux nixosTests.fish;

      # Test the fish_config tool by checking the generated splash page.
      # Since the webserver requires a port to run, it is not started.
      fishConfig =
        let
          fishScript = writeText "test.fish" ''
            set -x __fish_bin_dir ${finalAttrs.finalPackage}/bin
            echo $__fish_bin_dir
            cp -r ${finalAttrs.finalPackage}/share/fish/tools/web_config/* .
            chmod -R +w *

            # if we don't set `delete=False`, the file will get cleaned up
            # automatically (leading the test to fail because there's no
            # tempfile to check)
            ${lib.getExe gnused} -e 's@delete=True,@delete=False,@' -i webconfig.py

            # we delete everything after the fileurl is assigned
            ${lib.getExe gnused} -e '/fileurl =/q' -i webconfig.py
            echo "print(fileurl)" >> webconfig.py

            # and check whether the message appears on the page
            # cannot test the http server because it needs a localhost port
            cat (${python3}/bin/python ./webconfig.py \
              | tail -n1 | ${lib.getExe gnused} -e 's|file://||' \
            ) | ${lib.getExe gnugrep} -q 'a href="http://localhost.*Start the Fish Web config'
          '';
        in
        runCommand "test-web-config" { } ''
          HOME=$(mktemp -d)
          ${finalAttrs.finalPackage}/bin/fish ${fishScript} && touch $out
        '';
    };
    updateScript = nix-update-script { };
  };
})
