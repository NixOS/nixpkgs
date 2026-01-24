{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  firejail,
  networkmanager,
}:

stdenv.mkDerivation rec {
  pname = "firewarden";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "pigmonkey";
    repo = "firewarden";
    tag = version;
    hash = "sha256-Nq3SIZsw68FI3VkK5QdqdIHkV8tgz/eK5YvsIn0yxaU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 firewarden $out/bin/firewarden

    wrapProgram $out/bin/firewarden \
      --prefix PATH : ${
        lib.makeBinPath [
          firejail
          networkmanager
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "Open a program within a private Firejail sandbox";
    longDescription = ''
      Firewarden is a bash script that wraps application launches with Firejail
      sandboxing, creating isolated environments with temporary filesystems.
      It is particularly useful for mitigating harm caused by opening potentially
      malicious files, such as PDFs and images.
    '';
    homepage = "https://github.com/pigmonkey/firewarden";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.brett ];
    platforms = lib.platforms.linux;
    mainProgram = "firewarden";
  };
}
