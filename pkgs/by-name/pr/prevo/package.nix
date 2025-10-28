{
  lib,
  symlinkJoin,
  man,
  prevo-tools,
  prevo-data,
  makeWrapper,
}:

symlinkJoin rec {
  name = "prevo-${version}";
  inherit (prevo-tools) version;

  paths = [ prevo-tools ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/prevo \
      --prefix PATH ":" "${lib.makeBinPath [ man ]}" \
      --suffix XDG_DATA_DIRS : "${prevo-data}/share" \

  '';

  meta = {
    description = "Offline version of the Esperanto dictionary Reta Vortaro";
    longDescription = ''
      PReVo is the "portable" ReVo, i.e., the offline version
      of the Esperanto dictionary Reta Vortaro.
    '';
    homepage = "https://github.com/bpeel/prevodb";
    license = lib.licenses.gpl2Only;
    mainProgram = "prevo";
    maintainers = with lib.maintainers; [
      das-g
    ];
  };
}
