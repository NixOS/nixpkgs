{
  stdenv,
  lib,
  fetchFromCodeberg,
  makeWrapper,
  bash,
  coreutils,
  gnugrep,
  findutils,
  diffutils,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "doasedit";
  version = "1.0.9";

  src = fetchFromCodeberg {
    owner = "TotallyLeGIT";
    repo = "doasedit";
    rev = finalAttrs.version;
    hash = "sha256-gXwAgchcjp+bq9TC0SavmXOkzpJnqTC9InZIREs9fSo=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;
  dontConfigure = true;

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    wrapProgram $out/bin/doasedit \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          coreutils
          gnugrep
          findutils
          diffutils
        ]
      }
  '';

  meta = {
    description = "Edit files as root using an unprivileged editor";
    mainProgram = "doasedit";
    homepage = "https://codeberg.org/TotallyLeGIT/doasedit";
    changelog = "https://codeberg.org/TotallyLeGIT/doasedit/src/tag/${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ b-swist ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
