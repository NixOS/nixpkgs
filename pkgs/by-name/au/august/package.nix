{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "august";
  version = "0-unstable-2023-08-13";

  src = fetchFromGitHub {
    owner = "yoav-lavi";
    repo = "august";
    rev = "42b8a1bf5ca079aca1769d92315f70b193a9cd4a";
    hash = "sha256-58DZMoRH9PBbM4sok/XbUcwSXBeqUAmFZpffdMKQ+dE=";
  };

  cargoHash = "sha256-E1M/Soaz4+Gyxizc4VReZlfJB5gxrSz2ue3WI9fcNJA=";

  postInstall = ''
    mv $out/bin/{august-cli,ag}
  '';

  meta = with lib; {
    description = "Emmet-like language that produces JSON, TOML, or YAML";
    homepage = "https://github.com/yoav-lavi/august";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
    mainProgram = "ag";
  };
}
