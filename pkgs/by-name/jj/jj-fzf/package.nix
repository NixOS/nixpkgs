{
  lib,
  bashInteractive,
  coreutils,
  fetchFromGitHub,
  fzf,
  gawk,
  gnused,
  jujutsu,
  makeWrapper,
<<<<<<< HEAD
  pandoc,
  python3,
  unixtools,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "jj-fzf";
<<<<<<< HEAD
  version = "0.34.0";
=======
  version = "0.33.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "tim-janik";
    repo = "jj-fzf";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-aJyKVMg/yI2CmAx5TxN0w670Rq26ESdLzESgh8Jr4nE=";
  };

  strictDeps = true;
  buildInputs = [ bashInteractive ];
  nativeBuildInputs = [
    bashInteractive
    makeWrapper
    pandoc
    jujutsu
  ];

  dontConfigure = true;
  dontBuild = true;
  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  patches = [ ./nix-preflight.patch ];
  postPatch = ''
    substituteInPlace lib/gen-message.py \
      --replace-fail '/usr/bin/env -S python3 -B' '${python3}/bin/python -B'
    patchShebangs --build lib/*.sh
    patchShebangs --host jj-fzf *.sh contrib/*.sh
  '';
  postInstall = ''
    wrapProgram $out/bin/jj-fzf \
      --prefix PATH : ${
        lib.makeBinPath [
=======
    hash = "sha256-iVgX2Lu06t1pCQl5ZGgl3+lTv4HAPKbD/83STDtYhdU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D jj-fzf $out/bin/jj-fzf
    substituteInPlace $out/bin/jj-fzf \
      --replace-fail "/usr/bin/env bash" "${lib.getExe bashInteractive}"
    wrapProgram $out/bin/jj-fzf \
      --prefix PATH : ${
        lib.makeBinPath [
          bashInteractive
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
          coreutils
          fzf
          gawk
          gnused
          jujutsu
<<<<<<< HEAD
          python3
          unixtools.column
        ]
      }
  '';

  meta = {
    description = "Text UI for Jujutsu based on fzf";
    homepage = "https://github.com/tim-janik/jj-fzf";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ bbigras ];
    mainProgram = "jj-fzf";
    platforms = lib.platforms.all;
=======
        ]
      }
    runHook postInstall
  '';

  meta = with lib; {
    description = "Text UI for Jujutsu based on fzf";
    homepage = "https://github.com/tim-janik/jj-fzf";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
