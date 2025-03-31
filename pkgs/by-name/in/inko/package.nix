{
  lib,
  rustPlatform,
  fetchFromGitHub,
  llvm_17,
  libffi,
  libz,
  libxml2,
  ncurses,
  stdenv,
  makeWrapper,
  callPackage,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "inko";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "inko-lang";
    repo = "inko";
    tag = "v${version}";
    hash = "sha256-jVfAfR02R2RaTtzFSBoLuq/wdPaaI/eochrZaRVdmHY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-IOMhwcZHB5jVYDM65zifxCjVHWl1EBbxNA3WVmarWcs=";

  buildInputs = [
    libffi
    libz
    libxml2
    ncurses
    (lib.getLib stdenv.cc.cc)
  ];

  nativeBuildInputs = [
    llvm_17
    makeWrapper
  ];

  env = {
    INKO_STD = "${placeholder "out"}/lib";
    INKO_RT = "${placeholder "out"}/lib/runtime";
  };

  postFixup = ''
    wrapProgram $out/bin/inko \
      --prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}
  '';

  postInstall = ''
    mkdir -p $out/lib/runtime
    mv $out/lib/*.a $out/lib/runtime/
    cp -r std/src/* $out/lib/
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      simple = callPackage ./test.nix { };
    };
  };

  meta = {
    description = "Language for building concurrent software with confidence";
    homepage = "https://inko-lang.org/";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.feathecutie ] ++ lib.teams.ngi.members;
    platforms = lib.platforms.unix;
    mainProgram = "inko";
  };
}
