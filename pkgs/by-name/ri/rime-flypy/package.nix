{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  librime,
  rime-prelude,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "rime-flypy";
  version = "0-unstable-2025-12-27";
  src = fetchFromGitHub {
    owner = "cubercsl";
    repo = "rime-flypy";
    rev = "ea9455f25995a2878485c85b111c34a2a897adac";
    sha256 = "sha256-Lw54pNXUzsVv9OFp7c5Bf+pCCA0DWTslSTrN/raX9CM=";
  };

  nativeBuildInputs = [ librime ];
  prePatch = "cp -r ${rime-prelude}/* .";
  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Flypy phonetic=graphic input method for rime";
    homepage = "https://github.com/cubercsl/rime-flypy";

    # Packages are assumed unfree unless explicitly indicated otherwise
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ maikotan ];
    platforms = lib.platforms.all;
  };
}
