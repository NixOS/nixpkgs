{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  file,
  zip,
  wxGTK32,
  gtk3,
  contribPlugins ? false,
  hunspell,
  gamin,
  boost,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  name = "${pname}-${lib.optionalString contribPlugins "full-"}${version}";
  version = "20.03";
  pname = "codeblocks";

  src = fetchurl {
    url = "mirror://sourceforge/codeblocks/Sources/${version}/codeblocks-${version}.tar.xz";
    sha256 = "1idaksw1vacmm83krxh5zlb12kad3dkz9ixh70glw1gaibib7vhm";
  };

  nativeBuildInputs = [
    pkg-config
    file
    zip
    wrapGAppsHook3
  ];
  buildInputs =
    [
      wxGTK32
      gtk3
    ]
    ++ lib.optionals contribPlugins [
      hunspell
      gamin
      boost
    ];
  enableParallelBuilding = true;
  patches = [
    ./writable-projects.patch
    ./fix-clipboard-flush.patch
    # Fix build on non-x86 machines
    (fetchpatch {
      name = "remove-int3.patch";
      url = "https://github.com/arnholm/codeblocks_sfmirror/commit/d76c015c456561d2c7987935a5f4dc6c0932b0c4.patch";
      sha256 = "sha256-dpH33vGf2aNdYTeLwxglYDNbvwoY2bGSG6YFRyoGw+A=";
    })
    (fetchpatch {
      name = "remove-pragmas.patch";
      url = "https://github.com/arnholm/codeblocks_sfmirror/commit/966949d5ab7f3cb86e2a2c7ef4e853ee209b5a1a.patch";
      sha256 = "sha256-XjejjGOvDk3gl1/n9R69XATGLj5n7tOZNyG8vIlwfyg=";
    })
    # Fix build with GCC 11
    (fetchpatch {
      name = "use-gcc11-openfilelist.patch";
      url = "https://github.com/arnholm/codeblocks_sfmirror/commit/a5ea6ff7ff301d739d3dc8145db1578f504ee4ca.patch";
      sha256 = "sha256-kATaLej8kJf4xm0VicHfRetOepX8O9gOhwdna0qylvQ=";
    })
    (fetchpatch {
      name = "use-gcc11-ccmanager.patch";
      url = "https://github.com/arnholm/codeblocks_sfmirror/commit/04b7c50fb8c6a29b2d84579ee448d2498414d855.patch";
      sha256 = "sha256-VPy/M6IvNBxUE4hZRbLExFm0DJf4gmertrqrvsXQNz4=";
    })
    # Fix build with wxGTK 3.1.5
    (fetchpatch {
      name = "use-wxgtk315.patch";
      url = "https://github.com/arnholm/codeblocks_sfmirror/commit/2345b020b862ec855038dd32a51ebb072647f28d.patch";
      sha256 = "sha256-RRjwZA37RllnG8cJdBEnASpEd8z0+ru96fjntO42OvU=";
    })
    (fetchpatch {
      name = "fix-taskbar-icons.patch";
      url = "https://github.com/arnholm/codeblocks_sfmirror/commit/40eb88e3f2b933f19f9933e06c8d0899c54f5e25.patch";
      hash = "sha256-Gj5gtxX5QNYAeF+QrPS/bBHLLEmflSxUHSLUK3GSs0I=";
    })
    (fetchpatch {
      name = "fix-warnings.patch";
      url = "https://github.com/arnholm/codeblocks_sfmirror/commit/56ac0396fad7a5b4bbb40bb8c4b5fe1755078aef.patch";
      excludes = [ "src/src/environmentsettingsdlg.h" ];
      hash = "sha256-tl4rF9iAf1TzCIbKhVFqcxvr1IiPdwqLYZg0SY5BJ7I=";
    })
    (fetchpatch {
      name = "fix-getstring.patch";
      url = "https://github.com/arnholm/codeblocks_sfmirror/commit/dbdf5c5ea9e3161233f0588a7616b7e4fedc7870.patch";
      sha256 = "sha256-DrEMFluN8vs0LERa7ULGshl7HdejpsuvXAMjIr/K1fQ=";
    })
    # Fix build with wxGTK 3.1.6
    (fetchpatch {
      name = "remove-code-for-old-wx-1.patch";
      url = "https://github.com/arnholm/codeblocks_sfmirror/commit/8035dfdff321754819f79e3165401aa59bd8c7f7.patch";
      hash = "sha256-Z8Ap03W/XH5VwKFVudJr7rugb0BgI2dKJgQS4yIWbEM=";
    })
    (fetchpatch {
      name = "remove-code-for-old-wx-2.patch";
      url = "https://github.com/arnholm/codeblocks_sfmirror/commit/9a9c6a9d5e3e0f6eff5594ecd61a2222f073be9c.patch";
      hash = "sha256-SwYixvbRuXQ+jA1ijmClWkzqzzr0viVuFOAsihGc5dM=";
    })
    (fetchpatch {
      name = "remove-code-for-old-wx-3.patch";
      url = "https://github.com/arnholm/codeblocks_sfmirror/commit/c28746f4887f10e6f9f10eeafae0fb22ecdbf9c7.patch";
      hash = "sha256-1lcIiCnY2nBuUsffXC2rdglOE3ccIbogcgTx4M2Ee2I=";
    })
    (fetchpatch {
      name = "fix-notebookstyles.patch";
      url = "https://github.com/arnholm/codeblocks_sfmirror/commit/29315df024251850832583f73e67e515dae10830.patch";
      hash = "sha256-Uc1V0eEbNljnN+1Dqb/35MLSSoLjyuRZMTofgcXRyb8=";
    })
    (fetchpatch {
      name = "fix-regex.patch";
      url = "https://github.com/arnholm/codeblocks_sfmirror/commit/46720043319758cb0e798eb23520063583c40eaa.patch";
      hash = "sha256-Aix58T0JJcX/7VZukU/9i/nXh9GJywXC3yXEyUZK0js=";
    })
    (fetchpatch {
      name = "fix-build-with-clang.patch";
      url = "https://github.com/arnholm/codeblocks_sfmirror/commit/92cb2239662952e3b59b31e03edd653bb8066e64.patch";
      hash = "sha256-XI7JW9Nuueb7muKpaC2icM/CxhrCJtO48cLHK+BVWXI=";
    })
    (fetchpatch {
      name = "fix-normalize.patch";
      url = "https://github.com/archlinux/svntogit-community/raw/458eacb60bc0e71e3d333943cebbc41e75ed0956/trunk/sc_wxtypes-normalize.patch";
      hash = "sha256-7wEwDLwuNUWHUwHjFyq74sHiuEha1VexRLEX42rPZSs=";
    })
    # Fix HiDPI
    (fetchpatch {
      name = "update-about-dialog.patch";
      url = "https://github.com/arnholm/codeblocks_sfmirror/commit/a4aacc92640b587ad049cd6aa68c637e536e9ab5.patch";
      hash = "sha256-2S4sVn+Dq5y9xcxCkzQ+WeR+qWxAOLbQUZEnk060RI0=";
    })
    (fetchpatch {
      name = "add-display-info.patch";
      url = "https://github.com/arnholm/codeblocks_sfmirror/commit/f2f127cf5cd97c7da6a957a3f7764cb25cc9017e.patch";
      hash = "sha256-C0dVfC0NIHMXfWNlOwjzoGz5tmG2dlnU/EE92Jjebbs=";
    })
    (fetchpatch {
      name = "fix-hidpi.patch";
      url = "https://github.com/arnholm/codeblocks_sfmirror/commit/b2e4f1279804e1d11b71bc75eeb37072c3589296.patch";
      hash = "sha256-/Xp6ww9C3V6I67tTA4MrGpSGo3J0MXzFjzQU7RxY84U=";
    })
  ];
  preConfigure = "substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file";
  postConfigure = lib.optionalString stdenv.isLinux "substituteInPlace libtool --replace ldconfig ${stdenv.cc.libc.bin}/bin/ldconfig";
  configureFlags =
    [ "--enable-pch=no" ]
    ++ lib.optionals contribPlugins [
      (
        "--with-contrib-plugins" + lib.optionalString stdenv.isDarwin "=all,-FileManager,-NassiShneiderman"
      )
      "--with-boost-libdir=${boost}/lib"
    ];
  postInstall = lib.optionalString stdenv.isDarwin ''
    ln -s $out/lib/codeblocks/plugins $out/share/codeblocks/plugins
  '';

  meta = with lib; {
    maintainers = [ maintainers.linquize ];
    platforms = platforms.all;
    description = "Open source, cross platform, free C, C++ and Fortran IDE";
    longDescription = ''
      Code::Blocks is a free C, C++ and Fortran IDE built to meet the most demanding needs of its users.
      It is designed to be very extensible and fully configurable.
      Finally, an IDE with all the features you need, having a consistent look, feel and operation across platforms.
    '';
    homepage = "http://www.codeblocks.org";
    license = licenses.gpl3;
  };
}
