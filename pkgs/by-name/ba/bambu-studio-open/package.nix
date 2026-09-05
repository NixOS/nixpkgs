{
  bambu-studio,
  open-bamboo-networking,
  lib,
}:

let
  bambuStudioVersion = bambu-studio.version;
  obnVersion =
    let
      parts = lib.splitString "." bambuStudioVersion;
      prefix = lib.concatStringsSep "." (lib.take 3 parts);
    in
    "${prefix}.99";

  obn = open-bamboo-networking.override {
    pluginVersion = obnVersion;
    client = "bambu_studio";
  };
in
bambu-studio.overrideAttrs (oldAttrs: {
  pname = "bambu-studio-open";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs =
    (oldAttrs.nativeBuildInputs or [ ])
    ++ (lib.filter (p: (p.pname or p.name or "") == "wxwidgets") oldAttrs.buildInputs);

  patches = (oldAttrs.patches or [ ]) ++ [
    ./obn.patch
    ./skip-privacy.patch
  ];

  postPatch = (oldAttrs.postPatch or "") + ''
    substituteInPlace src/slic3r/Utils/NetworkAgent.cpp \
      --replace-fail "@obn_plugin_path@" "${obn}/plugins/libbambu_networking.so" \
      --replace-fail "@obn_bambu_source_path@" "${obn}/plugins/libBambuSource.so"
  '';

  meta = oldAttrs.meta // {
    description = "Bambu Studio with open-bamboo-networking (FOSS networking plugin)";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ mio ];
  };
})
