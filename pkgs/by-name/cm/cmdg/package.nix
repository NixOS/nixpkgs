{
  lib,
  buildGoModule,
  fetchFromGitHub,
  lynx,
  gnupg,
  less,
  nano,
  makeBinaryWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "cmdg";
  version = "1.05-unstable-2026-06-11";

  src = fetchFromGitHub {
    owner = "ThomasHabets";
    repo = "cmdg";
    rev = "069abc1f2c249ffef49cb3910e8f901639de7618";
    hash = "sha256-wUC90UucAHkNvjvU2vEp35tpOAzNavLi8qJCgIG14Bc=";
  };

  vendorHash = "sha256-r6gjZOWcztX0N9BualwRFulxo/zlA3fvF1CNjIeSZd0=";

  __structuredAttrs = true;
  strictDeps = true;

  subPackages = [ "cmd/cmdg" ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postFixup = ''
    wrapProgram $out/bin/cmdg  \
      --prefix PATH : "${
        lib.makeBinPath [
          lynx
          gnupg
        ]
      }"  \
      --set-default PAGER "${lib.getExe less}"  \
      --set-default EDITOR "${lib.getExe nano}"
  '';

  meta = {
    description = "Command line Gmail client";
    homepage = "https://github.com/ThomasHabets/cmdg";
    mainProgram = "cmdg";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
