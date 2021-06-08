{ lib
, stdenv
, fetchgit
, autoreconfHook
, pkg-config
, wxGTK30-gtk3
, ffmpeg
, proj
, perl532
, unscii
, python
, libGL
, libGLU
, xlibsWrapper
, docbook2x
, docbook5
}:

stdenv.mkDerivation rec {
  pname = "survex";
  version = "1.2.44";

  nativeBuildInputs = [ docbook5 x11 libGL libGLU docbook2x autoreconfHook pkg-config wxGTK30-gtk3 ffmpeg proj python (perl532.withPackages (perlPackages: with perlPackages; [ LocalePO ] )) ];

  src = fetchgit {
    url = "git://git.survex.com/survex";
    rev = version;
    sha256 = "11gaqmabrf3av665jy3mr0m8hg76fmvnd0g3rghzmyh8d8v6xk34";
  };

  # Docs rely on sgmltools-lite, a package that would be quite complex to
  # provide as it is quite old. So this preConfigure hook effectively disables
  # the doc generation. An example of packaging sgmltools-lite from Gentoo can
  # be found here:
  # https://gitweb.gentoo.org/repo/gentoo.git/tree/app-text/sgmltools-lite/sgmltools-lite-3.0.3-r15.ebuild?id=0b8b716331049599ea3299981e3a9ea6e258c5e0

  preConfigure = ''
    echo "" > doc/Makefile.am
  '';

  postConfigure = ''
    # substituteInPlace doc/Makefile --replace "docbook2man" "docbook2man --sgml" # Will be needed once sgmltools-lite is packaged.
    substituteInPlace lib/make-pixel-font --replace /usr/share/unifont/unifont.hex ${unscii.extra}/share/fonts/misc/unifont.hex
    patchShebangs .
  '';

  meta = with lib; {
    description = "Free Software/Open Source software package for mapping caves";
    longDescription = ''
      Survex is a Free Software/Open Source software package for mapping caves,
      licensed under the GPL. It is designed to be portable and can be run on a
      variety of platforms, including Linux/Unix, macOS, and Microsoft Windows.
    '';
    homepage = "https://survex.com/";
    changelog = "https://github.com/ojwb/survex/blob/${version}/NEWS";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.matthewcroughan ];
    platforms = platforms.all;
  };
}
