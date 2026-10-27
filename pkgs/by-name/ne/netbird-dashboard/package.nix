{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "netbird-dashboard";
  version = "2.96.0";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "dashboard";
    rev = "v${version}";
    hash = "sha256-pQ876Thp4om6RmLpJAAJUX8J2gcXwjV8WIxjyuzkri0=";
  };

  npmDepsHash = "sha256-PiRXoYa/TQ/jTSw9E6V8HYM6t2Hl20fuPu6zx6s9WpM=";
  npmFlags = [ "--legacy-peer-deps" ];

  installPhase = ''
    cp -R out $out
  '';

  env = {
    CYPRESS_INSTALL_BINARY = 0;
    NEXT_PUBLIC_DASHBOARD_VERSION = version;
  };

  meta = {
    description = "NetBird Management Service Web UI Panel";
    homepage = "https://github.com/netbirdio/dashboard";
    license = lib.licenses.bsd3;
    maintainers = [
    ];
  };
}
