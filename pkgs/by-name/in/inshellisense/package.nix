{ lib, stdenv, buildNpmPackage, fetchFromGitHub, cacert }:

buildNpmPackage rec {
  pname = "inshellisense";
  version = "0.0.1-rc.18";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-9cSygGQar2rD3lorehlNmUzd0ZnABNJSJwmoNH3MTmk=";
  };

  npmDepsHash = "sha256-/FSzeHPgVb5OB6mjP5GYAYBdTmk93xyWJI+NH7L61Do=";

  # Needed for dependency `@homebridge/node-pty-prebuilt-multiarch`
  # On Darwin systems the build fails with,
  #
  # npm ERR! ../src/unix/pty.cc:413:13: error: use of undeclared identifier 'openpty'
  # npm ERR!   int ret = openpty(&master, &slave, nullptr, NULL, static_cast<winsi ze*>(&winp));
  #
  # when `node-gyp` tries to build the dep. The below allows `npm` to download the prebuilt binary.
  makeCacheWritable = stdenv.hostPlatform.isDarwin;
  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin cacert;

  meta = with lib; {
    description = "IDE style command line auto complete";
    homepage = "https://github.com/microsoft/inshellisense";
    license = licenses.mit;
    maintainers = [ maintainers.malo ];
  };
}

