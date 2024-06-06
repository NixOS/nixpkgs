{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "piped";
  version = "0-unstable-2024-07-12";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "Piped";
    rev = "f9ef6a34bbd3f8b6e0888a5bf3597accdcd5e6c9";
    hash = "sha256-Zfnd62/vG8LUy/6NSrn/U8ScSTnQ6lZboPckdnJjL70=";
  };

  nativeBuildInputs = [nodejs pnpm.configHook];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-o6xNq0WFQlwwlFcYlHWWQ8STYTDU+9OTQwBBtMrJu0o=";
  };

  buildPhase = ''
    pnpm build
  '';

  installPhase = ''
    cp -r dist/ $out
  '';

  meta = {
    description = "An alternative privacy-friendly YouTube frontend which is efficient by design";
    homepage = "https://github.com/TeamPiped/Piped";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [defelo];
  };
})
