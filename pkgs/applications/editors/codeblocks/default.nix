{ lib, stdenv, fetchurl, fetchpatch, pkg-config, file, zip, wxGTK31-gtk3, gtk3
, contribPlugins ? false, hunspell, gamin, boost, wrapGAppsHook
}:

with lib;

stdenv.mkDerivation rec {
  name = "${pname}-${lib.optionalString contribPlugins "full-"}${version}";
  version = "20.03";
  pname = "codeblocks";

  src = fetchurl {
    url = "mirror://sourceforge/codeblocks/Sources/${version}/codeblocks-${version}.tar.xz";
    sha256 = "1idaksw1vacmm83krxh5zlb12kad3dkz9ixh70glw1gaibib7vhm";
  };

  nativeBuildInputs = [ pkg-config file zip wrapGAppsHook ];
  buildInputs = [ wxGTK31-gtk3 gtk3 ]
    ++ optionals contribPlugins [ hunspell gamin boost ];
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
      name = "fix-getstring.patch";
      url = "https://github.com/arnholm/codeblocks_sfmirror/commit/dbdf5c5ea9e3161233f0588a7616b7e4fedc7870.patch";
      sha256 = "sha256-DrEMFluN8vs0LERa7ULGshl7HdejpsuvXAMjIr/K1fQ=";
    })
  ];
  preConfigure = "substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file";
  postConfigure = optionalString stdenv.isLinux "substituteInPlace libtool --replace ldconfig ${stdenv.cc.libc.bin}/bin/ldconfig";
  configureFlags = [ "--enable-pch=no" ] ++ optionals contribPlugins [
    ("--with-contrib-plugins" + optionalString stdenv.isDarwin "=all,-FileManager,-NassiShneiderman")
    "--with-boost-libdir=${boost}/lib"
  ];
  postInstall = optionalString stdenv.isDarwin ''
    ln -s $out/lib/codeblocks/plugins $out/share/codeblocks/plugins
  '';

  meta = {
    maintainers = [ maintainers.linquize ];
    platforms = platforms.all;
    description = "The open source, cross platform, free C, C++ and Fortran IDE";
    longDescription =
      ''
        Code::Blocks is a free C, C++ and Fortran IDE built to meet the most demanding needs of its users.
        It is designed to be very extensible and fully configurable.
        Finally, an IDE with all the features you need, having a consistent look, feel and operation across platforms.
      '';
    homepage = "http://www.codeblocks.org";
    license = licenses.gpl3;
  };
}
