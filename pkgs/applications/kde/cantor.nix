{ mkDerivation, lib, extra-cmake-modules, kdoctools, qtxmlpatterns, kxmlgui, kparts, syntax-highlighting, knewstuff, ktexteditor, poppler, kpty
, analitzaSupport ? true, analitza ? null
, juliaSupport ? false, julia ? null
, spectreSupport ? false, libspectre ? null
, luajitSupport ? false, luajit ? null
, qalculateSupport ? false, libqalculate ? null
}:

assert analitzaSupport || juliaSupport || spectreSupport || luajitSupport || qalculateSupport;

assert analitzaSupport -> analitza != null;
assert juliaSupport -> julia != null;
assert spectreSupport -> libspectre != null;
assert luajitSupport -> luajit != null;
assert qalculateSupport -> libqalculate != null;

mkDerivation {
  name = "cantor";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/cantor";
    description = "Front-end to powerful mathematics and statistics packages";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    knewstuff
    kparts
    kpty
    ktexteditor
    kxmlgui
    qtxmlpatterns
    poppler
    syntax-highlighting
  ] ++ lib.optional analitzaSupport analitza
    ++ lib.optional juliaSupport julia
    ++ lib.optional luajitSupport luajit
    ++ lib.optional qalculateSupport libqalculate
    ++ lib.optional spectreSupport libspectre;
}
