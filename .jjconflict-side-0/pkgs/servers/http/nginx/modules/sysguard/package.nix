{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "sysguard";
  version = "0-unstable-2017-03-21";

  src = fetchFromGitHub {
    owner = "vozlt";
    repo = "nginx-module-sysguard";
    rev = "e512897f5aba4f79ccaeeebb51138f1704a58608";
    sha256 = "19c6w6wscbq9phnx7vzbdf4ay6p2ys0g7kp2rmc9d4fb53phrhfx";
  };

  meta = {
    description = "Nginx sysguard module";
    homepage = "https://github.com/vozlt/nginx-module-sysguard";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
