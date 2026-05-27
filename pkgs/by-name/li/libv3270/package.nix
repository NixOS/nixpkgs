{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  lib3270,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libv3270";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "PerryWerneck";
    repo = "libv3270";
    tag = finalAttrs.version;
    hash = "sha256-Cn/to1/7mH1Ygjcx12mMf52PTcz4smy/+bwWH1mbT9s=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    gtk3
    lib3270
  ];

  postPatch = ''
    # lib3270_build_data_filename is relative to lib3270's share - not ours.
    for f in $(find . -type f -iname "*.c"); do
      sed -i -e "s@lib3270_build_data_filename(@g_build_filename(\"$out/share/pw3270\", @" "$f"
    done
  '';

  enableParallelBuilding = true;

  meta = {
    description = "3270 Virtual Terminal for GTK";
    homepage = "https://github.com/PerryWerneck/libv3270";
    changelog = "https://github.com/PerryWerneck/libv3270/blob/master/CHANGELOG";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ vifino ];
  };
})
