{
  stdenv,
  stdenvNoCC,
  libarchive,
  p7zip,
  installShellFiles,
  testers,
  version,
  meta,
  swift,
  enableSwiftDylibFix ? false,
  fixSwiftDylib,
  repoSrc,
  releaseSrc,
  mas-from-release,
}:
let
  stdenvChosen = if enableSwiftDylibFix then stdenv else stdenvNoCC;
in
stdenvChosen.mkDerivation rec {
  pname = "mas-from-release";
  inherit version meta;
  completionSrc = "${repoSrc}/contrib/completion";
  srcs = [
    releaseSrc
    completionSrc
  ];

  nativeBuildInputs = [
    installShellFiles
    libarchive
    p7zip
  ];

  unpackPhase = ''
    runHook preUnpack

    7z x "${releaseSrc}"
    bsdtar -xf Payload~

    cp --recursive "${completionSrc}" .

    runHook postUnpack
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp mas "$out/bin/mas"

    ls -lah

    installShellCompletion --cmd mas --bash completion/mas-completion.bash
    installShellCompletion --cmd mas --fish completion/mas.fish

    runHook postInstall
  '';

  postFixup = if enableSwiftDylibFix then (fixSwiftDylib swift "@executable_path/../lib") else "";

  passthru.tests = {
    version = testers.testVersion {
      package = mas-from-release;
      command = "mas version";
    };
  };
}
