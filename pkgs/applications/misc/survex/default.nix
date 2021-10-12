{ lib
, stdenv
, fetchgit
, autoreconfHook
, pkg-config
, wxGTK30-gtk3
, wxmac
, ffmpeg
, proj_7
, perl532
, unscii
, python
, libGL
, libGLU
, xlibsWrapper
, docbook2x
, docbook5
, Carbon
, Cocoa
}:

let
  perlenv = perl532.withPackages (perlPackages: with perlPackages; [ LocalePO ] );
in
stdenv.mkDerivation rec {
  pname = "survex";
  version = "1.2.44";

  nativeBuildInputs = [ docbook5 docbook2x autoreconfHook pkg-config perlenv python ];

  buildInputs = [
    libGL libGLU ffmpeg proj_7
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    wxmac Carbon Cocoa
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    wxGTK30-gtk3 xlibsWrapper
  ];

  src = fetchgit {
    url = "git://git.survex.com/survex";
    rev = version;
    sha256 = "11gaqmabrf3av665jy3mr0m8hg76fmvnd0g3rghzmyh8d8v6xk34";
  };

  enableParallelBuilding = true;

  # Docs rely on sgmltools-lite, a package that would be quite complex to
  # provide as it is quite old. So this preConfigure hook effectively disables
  # the doc generation. An example of packaging sgmltools-lite from Gentoo can
  # be found here:
  # https://gitweb.gentoo.org/repo/gentoo.git/tree/app-text/sgmltools-lite/sgmltools-lite-3.0.3-r15.ebuild?id=0b8b716331049599ea3299981e3a9ea6e258c5e0

  postPatch = ''
    patchShebangs .
    echo "" > doc/Makefile.am
    # substituteInPlace doc/Makefile --replace "docbook2man" "docbook2man --sgml" # Will be needed once sgmltools-lite is packaged.
    for perltool in './extract-msgs.pl' './gettexttomsg.pl' '$(srcdir)/gdtconvert' '$(srcdir)/gen_img2aven'; do
      substituteInPlace src/Makefile.am \
        --replace "$perltool" "${perlenv}/bin/perl $perltool"
    done
    substituteInPlace lib/Makefile.am \
      --replace '$(srcdir)/make-pixel-font' '${perlenv}/bin/perl $(srcdir)/make-pixel-font'
    substituteInPlace lib/make-pixel-font --replace /usr/share/unifont/unifont.hex ${unscii.extra}/share/fonts/misc/unifont.hex
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
