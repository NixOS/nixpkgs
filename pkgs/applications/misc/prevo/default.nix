{ lib, symlinkJoin, prevo-tools, prevo-data, makeWrapper }:

symlinkJoin rec {
  name = "prevo-${version}";
  inherit (prevo-tools) version;

  paths = [ prevo-tools ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/prevo \
      --prefix XDG_DATA_DIRS : "${prevo-data}/share"
  '';

  meta = with lib; {
    description = "offline version of the Esperanto dictionary Reta Vortaro";
    longDescription = ''
      PReVo is the "portable" ReVo, i.e., the offline version
      of the Esperanto dictionary Reta Vortaro.
    '';
    homepage = "https://github.com/bpeel/prevodb";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.das-g ];
    platforms = platforms.linux;
  };
}
