{ stdenv, fetchFromGitHub
, cmake, wrapGAppsHook
, libX11, libzip, glfw, libpng, xorg, gnome3
}:

stdenv.mkDerivation rec {
  pname = "tev";
  version = "1.15";

  src = fetchFromGitHub {
    owner = "Tom94";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "173nxvj30xmbdj8fc3rbw0mlicxy6zbhxv01i7z5nmcdvpamkdx6";
  };

  nativeBuildInputs = [ cmake wrapGAppsHook ];
  buildInputs = [ libX11 libzip glfw libpng ]
    ++ (with xorg; [ libXrandr libXinerama libXcursor libXi libXxf86vm ]);

  dontWrapGApps = true; # We also need zenity (see below)

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "/usr/" "''${out}/"
  '';

  postInstall = ''
    wrapProgram $out/bin/tev \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH ":" "${gnome3.zenity}/bin"
  '';

  meta = with stdenv.lib; {
    description = "A high dynamic range (HDR) image comparison tool";
    longDescription = ''
      A high dynamic range (HDR) image comparison tool for graphics people. tev
      allows viewing images through various tonemapping operators and inspecting
      the values of individual pixels. Often, it is important to find exact
      differences between pairs of images. For this purpose, tev allows rapidly
      switching between opened images and visualizing various error metrics (L1,
      L2, and relative versions thereof). To avoid clutter, opened images and
      their layers can be filtered by keywords.
      While the predominantly supported file format is OpenEXR certain other
      types of images can also be loaded.
    '';
    inherit (src.meta) homepage;
    changelog = "https://github.com/Tom94/tev/releases/tag/v${version}";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
