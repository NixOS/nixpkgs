{ lib
, stdenv
, fetchFromGitHub
, testers
, bison
, cadical
, cbmc
, cmake
, flex
, makeWrapper
, perl
}:

stdenv.mkDerivation rec {
  pname = "cbmc";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "diffblue";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-mPRkkKN7Hz9Qi6a3fEwVFh7a9OaBFcksNw9qwNOarao=";
  };

  nativeBuildInputs = [
    bison
    cmake
    flex
    perl
    makeWrapper
  ];

  buildInputs = [ cadical ];

  # do not download sources
  # link existing cadical instead
  patches = [
    ./0001-Do-not-download-sources-in-cmake.patch
  ];

  postPatch = ''
    # do not hardcode gcc
    substituteInPlace "scripts/bash-autocomplete/extract_switches.sh" \
      --replace "gcc" "$CC" \
      --replace "g++" "$CXX"
    # fix library_check.sh interpreter error
    patchShebangs .
  '' + lib.optionalString (!stdenv.cc.isGNU) ''
    # goto-gcc rely on gcc
    substituteInPlace "regression/CMakeLists.txt" \
      --replace "add_subdirectory(goto-gcc)" ""
  '';

  postInstall = ''
    # goto-cc expects ls_parse.py in PATH
    mkdir -p $out/share/cbmc
    mv $out/bin/ls_parse.py $out/share/cbmc/ls_parse.py
    chmod +x $out/share/cbmc/ls_parse.py
    wrapProgram $out/bin/goto-cc \
      --prefix PATH : "$out/share/cbmc" \
  '';

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isGNU [
    # Needed with GCC 12 but breaks on darwin (with clang)
    "-Wno-error=maybe-uninitialized"
  ] ++ lib.optionals stdenv.cc.isClang [
    # fix "argument unused during compilation"
    "-Wno-unused-command-line-argument"
  ]);

  # TODO: add jbmc support
  cmakeFlags = [ "-DWITH_JBMC=OFF" "-Dsat_impl=cadical" "-Dcadical_INCLUDE_DIR=${cadical.dev}/include" ];

  passthru.tests.version = testers.testVersion {
    package = cbmc;
    command = "cbmc --version";
  };

  meta = with lib; {
    description = "CBMC is a Bounded Model Checker for C and C++ programs";
    homepage = "http://www.cprover.org/cbmc/";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ jiegec ];
    platforms = platforms.unix;
    # error: no member named 'aligned_alloc' in the global namespace
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
