{
  lib,
  stdenvNoCC,
  fetchurl,
<<<<<<< HEAD
  installShellFiles,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  libarchive,
  p7zip,
  testers,
  mas,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mas";
<<<<<<< HEAD
  version = "4.1.0";

  src =
    let
      sources =
        {
          x86_64-darwin = {
            arch = "x86_64";
            hash = "sha256-9GkAV2gitqtZ7Ew/QVXDj3tDTbh5uwBxPtYdLSnucZE=";
          };
          aarch64-darwin = {
            arch = "arm64";
            hash = "sha256-8zaZOPOCyLHOFmHhviJXIy5SB5trqQM/MFHhB9ygilQ=";
          };
        }
        .${stdenvNoCC.hostPlatform.system}
          or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
    in
    fetchurl {
      url = "https://github.com/mas-cli/mas/releases/download/v${version}/mas-${version}-${sources.arch}.pkg";
      inherit (sources) hash;
    };

  nativeBuildInputs = [
    installShellFiles
=======
  version = "2.2.2";

  src = fetchurl {
    url = "https://github.com/mas-cli/mas/releases/download/v${version}/mas-${version}.pkg";
    hash = "sha256-v+tiD5ZMVFzeShyuOt8Ss3yw6p8VjopHaMimOQznL6o=";
  };

  nativeBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    libarchive
    p7zip
  ];

  unpackPhase = ''
    runHook preUnpack

    7z x $src
    bsdtar -xf Payload~

    runHook postUnpack
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall

<<<<<<< HEAD
    install -Dm755 usr/local/opt/mas/bin/mas $out/bin/mas

    installManPage usr/local/opt/mas/share/man/man1/mas.1
    installShellCompletion --bash usr/local/opt/mas/etc/bash_completion.d/mas
    installShellCompletion --fish usr/local/opt/mas/share/fish/vendor_completions.d/mas.fish
=======
    mkdir -p $out/bin
    cp mas $out/bin
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    runHook postInstall
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = mas;
      command = "mas version";
    };
  };

<<<<<<< HEAD
  meta = {
    description = "Mac App Store command line interface";
    homepage = "https://github.com/mas-cli/mas";
    license = lib.licenses.mit;
    mainProgram = "mas";
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Mac App Store command line interface";
    homepage = "https://github.com/mas-cli/mas";
    license = licenses.mit;
    mainProgram = "mas";
    maintainers = with maintainers; [
      steinybot
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      zachcoyle
    ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
