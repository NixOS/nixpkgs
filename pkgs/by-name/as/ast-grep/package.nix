{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "ast-grep";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "ast-grep";
    repo = "ast-grep";
    rev = version;
    hash = "sha256-/lWvFYSE4gFbVPlJMROGcb86mVviGdh1tFAY74qTTX4=";
  };

  cargoHash = "sha256-r1vfh2JtBjWFgXrijlFxPyRr8LRAIogiA2TZHI5MJRM=";

  # Work around https://github.com/NixOS/nixpkgs/issues/166205.
  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_LDFLAGS = "-l${stdenv.cc.libcxx.cxxabi.libName}";
  };

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  checkFlags = [
    # disable flaky test
    "--skip=test::test_load_parser_mac"

    # BUG: Broke by 0.12.1 update (https://github.com/NixOS/nixpkgs/pull/257385)
    # Please check if this is fixed in future updates of the package
    "--skip=verify::test_case::tests::test_unmatching_id"
  ] ++ lib.optionals (with stdenv.hostPlatform; (isDarwin && isx86_64) || (isLinux && isAarch64)) [
    # x86_64-darwin: source/benches/fixtures/json-mac.so\' (no such file), \'/private/tmp/nix-build-.../source/benches/fixtures/json-mac.so\' (mach-o file, but is an incompatible architecture (have \'arm64\', need \'x86_64h\' or \'x86_64\'))" })
    # aarch64-linux: /build/source/benches/fixtures/json-linux.so: cannot open shared object file: No such file or directory"
    "--skip=test::test_load_parser"
    "--skip=test::test_register_lang"
  ];

  meta = with lib; {
    mainProgram = "sg";
    description = "A fast and polyglot tool for code searching, linting, rewriting at large scale";
    homepage = "https://ast-grep.github.io/";
    changelog = "https://github.com/ast-grep/ast-grep/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ montchr lord-valen cafkafk ];
  };
}
