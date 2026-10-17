{
  lib,
  nix-update-script,
  rustPlatform,
  makeWrapper,
  shared-mime-info,
  fetchFromGitLab,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "allmytoes";
  version = "0.5.1";

  src = fetchFromGitLab {
    owner = "allmytoes";
    repo = "allmytoes";
    tag = finalAttrs.version;
    hash = "sha256-BYKcDJN/uKESj0pnb2xvrx1lO6rOGdi+PVT6ywZqjbQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  cargoHash = "sha256-Pzbruv1E4mMohw//lf1JBoK+4BHDJVr4/9xXE4FrWbA==";

  postInstall = ''
    wrapProgram "$out/bin/allmytoes" --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
  '';

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Provides thumbnails by using the freedesktop-specified thumbnail database (aka XDG standard)";
    homepage = "https://gitlab.com/allmytoes/allmytoes";
    mainProgram = "allmytoes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luminarleaf ];
  };
})
