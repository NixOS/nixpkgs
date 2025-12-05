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
  pandoc,
  python3,
  unixtools,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "jj-fzf";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "tim-janik";
    repo = "jj-fzf";
    tag = "v${version}";
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
          coreutils
          fzf
          gawk
          gnused
          jujutsu
          python3
          unixtools.column
        ]
      }
  '';

  meta = with lib; {
    description = "Text UI for Jujutsu based on fzf";
    homepage = "https://github.com/tim-janik/jj-fzf";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.all;
  };
}
