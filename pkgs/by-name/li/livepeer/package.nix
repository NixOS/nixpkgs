{
  lib,
  fetchFromGitHub,
  buildGoModule,
  pkg-config,
  ffmpeg,
  gnutls,
  nix-update-script,
}:

buildGoModule rec {
  pname = "livepeer";
  version = "0.5.20";

  proxyVendor = true;
  vendorHash = "sha256-aRZoAEnRai8i5H08ReW8lEFlbmarYxU0lBRhR/Llw+M=";

  src = fetchFromGitHub {
    owner = "livepeer";
    repo = "go-livepeer";
    rev = "refs/tags/v${version}";
    hash = "sha256-cOxIL093Mi+g9Al/SQJ6vdaeBAXUN6ZGsSaVvEIiJpU=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    ffmpeg
    gnutls
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Official Go implementation of the Livepeer protocol";
    homepage = "https://livepeer.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ elitak ];
    mainProgram = "livepeer";
  };
}
