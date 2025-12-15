{
  lib,
  rustPlatform,
  fetchFromGitHub,
  llvm,
  libffi,
  libz,
  libxml2,
  ncurses,
  stdenv,
  makeWrapper,
  callPackage,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "inko";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "inko-lang";
    repo = "inko";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZHVOwYvNRL2ObZt2PvayoqvS64MumN4oXQOgeCWbEUM=";
  };

  cargoHash = "sha256-BHrbqPMQnhw8pjN8e0/qW1rPe/fMhs2iUbRVPt5ATrg=";

  buildInputs = [
    libffi
    libz
    libxml2
    ncurses
    (lib.getLib stdenv.cc.cc)
  ];

  nativeBuildInputs = [
    llvm
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

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Language for building concurrent software with confidence";
    homepage = "https://inko-lang.org/";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.feathecutie ];
    teams = [ lib.teams.ngi ];
    platforms = lib.platforms.unix;
    mainProgram = "inko";
  };
})
