{
  buildNpmPackage,
  lib,
  fetchurl,
  fetchFromGitHub,
}:

buildNpmPackage {
  pname = "hyper-cmd-utils";
  version = "1.0.0";

  npmDepsHash = "sha256-FgUIHdmmeRhVoXisc2WdWUNA76vzFCfkM58RpqLoK5s=";

  dontNpmBuild = true;

  makeCacheWritable = true;

  src = fetchFromGitHub {
    owner = "holepunchto";
    repo = "hyper-cmd-utils";
    rev = "b8f1da1a1f4bc28ff9dbdbb6f4d777c2378d6137";
    hash = "sha256-fQkXCor6Fnl0E5XAgIm7SP4Nq6oTHdQtKFEbvXoXx9A=";
  };

  patches = [
    # TODO: remove after this is merged: https://github.com/holepunchto/hyper-cmd-utils/pull/6
    (fetchurl {
      url = "https://github.com/holepunchto/hyper-cmd-utils/commit/9bec5ca0a58fc9ba263afe750134f82e7e1c30c4.patch";
      hash = "sha256-p32r5y8PnROePbpsBLYza1+lGR2n0amSdo8qDWhyYxo=";
    })
  ];

  meta = {
    description = "HyperCmd Utils";
    homepage = "https://github.com/holepunchto/hyper-cmd-utils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ davhau ];
    mainProgram = "hyper-cmd-utils";
    platforms = lib.platforms.all;
  };
}
