{
  lib,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
  ronn,
  pkg-config,
  libsodium,
}:
rustPlatform.buildRustPackage rec {
  pname = "bupstash";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "andrewchambers";
    repo = "bupstash";
    rev = "v${version}";
    sha256 = "sha256-Ekjxna3u+71s1q7jjXp7PxYUQIfbp2E+jAqKGuszU6g=";
  };

  cargoHash = "sha256-kWUAI25ag9ghIhn36NF+SunRtmbS0HzsZsxGJujmuG4=";

  nativeBuildInputs = [
    ronn
    pkg-config
    installShellFiles
  ];
  buildInputs = [ libsodium ];

  postBuild = ''
    RUBYOPT="-KU -E utf-8:utf-8" ronn -r doc/man/*.md
  '';

  postInstall = ''
    installManPage doc/man/*.[1-9]
  '';

  meta = with lib; {
    description = "Easy and efficient encrypted backups";
    homepage = "https://bupstash.io";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ ];
    mainProgram = "bupstash";
  };
}
