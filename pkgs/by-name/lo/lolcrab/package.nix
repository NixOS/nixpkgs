{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lolcrab";
  version = "0.4.1";
  cargoHash = "sha256-xuHTh3Fo/6gNGrcPz7WArJ1nXQvWuHAopYBmVyCXUCU=";

  __structuredAttrs = true;

  meta = {
    description = "Like lolcat but with noise and more colorful. This is a fork of lcat.";
    homepage = "https://github.com/mazznoer/lolcrab";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };

  src = fetchFromGitHub {
    owner = "mazznoer";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-AfdCK8Xi523o45Ft9aLZPt4dZDdNLsn04QFCUVdgS5A=";
  };
})
