{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  flex,
  itstool,
  wrapGAppsHook3,
  desktop-file-utils,
  exiv2,
  libgsf,
  taglib,
  poppler,
  samba,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-commander";
  version = "1.18.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-commander";
    tag = finalAttrs.version;
    hash = "sha256-rSaj1Fg2seZKlzlERZZmz80kxJT1vZ+INiJlWfZ9m6g=";
  };

  postPatch =
    # hard-coded schema paths
    ''
      substituteInPlace src/gnome-cmd-data.cc plugins/fileroller/file-roller-plugin.cc \
        --replace-fail \
          '/share/glib-2.0/schemas' \
          '/share/gsettings-schemas/${finalAttrs.finalPackage.name}/glib-2.0/schemas'
    ''
    # Fix missing semicolon in file-list sort_by_owner / sort_by_group
    + ''
      substituteInPlace src/gnome-cmd-file-list.cc \
        --replace-fail "GetGfileAttributeString(G_FILE_ATTRIBUTE_OWNER_USER), raising)" \
                 "GetGfileAttributeString(G_FILE_ATTRIBUTE_OWNER_USER), raising);" \
        --replace-fail "GetGfileAttributeString(G_FILE_ATTRIBUTE_OWNER_GROUP), raising)" \
                 "GetGfileAttributeString(G_FILE_ATTRIBUTE_OWNER_GROUP), raising);"
    ''
    # Update C/C++ language standards to C17 and C++17 to meet GTest 1.10+ requirements and ensure consistency across tests
    + ''
      substituteInPlace meson.build \
        --replace-fail "'cpp_std=gnu++11', 'build.cpp_std=gnu++11'" "'cpp_std=gnu++17', 'build.cpp_std=gnu++17'"
      substituteInPlace tests/meson.build \
        --replace-fail "'c_std=c14', 'cpp_std=c++14'" "'c_std=c17', 'cpp_std=c++17'"
    '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    flex
    itstool
    wrapGAppsHook3
    desktop-file-utils
  ];

  buildInputs = [
    exiv2
    libgsf
    taglib
    poppler
    samba
    gtest
  ];

  meta = {
    description = "Fast and powerful twin-panel file manager for the Linux desktop";
    homepage = "https://gcmd.github.io";
    license = lib.licenses.gpl2Plus;
    mainProgram = "gnome-commander";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
