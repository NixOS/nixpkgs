{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "spoof";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "feross";
    repo = "spoof";
    rev = "v${version}";
    hash = "sha256-oysURKLQ/rbGAvsy3K0OmDRHUqRKa8S8l5ihBjNqYXc=";
  };

  npmDepsHash = "sha256-jf0tcsftXoYy6K3PcXgSU+3PAb6Ux9BsVpOX79TI4/o=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmFlags = [ "--ignore-scripts" ];

  dontNpmBuild = true;

  meta = {
    description = "Easily spoof your MAC address in OS X & Linux";
    homepage = "https://github.com/feross/spoof";
    license = lib.licenses.mit;
    mainProgram = "spoof";
    maintainers = with lib.maintainers; [ modderme123 ];
  };
}
