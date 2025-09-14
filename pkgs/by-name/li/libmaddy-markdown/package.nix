{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmaddy-markdown";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "progsource";
    repo = "maddy";
    tag = finalAttrs.version;
    hash = "sha256-WMueY199ngw9BtHSY8zypfPZjWaQsSLUx8FDfQbBt5g=";
  };

  nativeBuildInputs = [
    cmake
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C++ Markdown to HTML header-only parser library";
    homepage = "https://github.com/progsource/maddy";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.normalcea ];
    platforms = lib.platforms.unix;
  };
})
