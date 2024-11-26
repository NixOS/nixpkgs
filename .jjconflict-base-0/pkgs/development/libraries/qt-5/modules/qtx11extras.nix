{ qtModule, qtbase }:

qtModule {
  pname = "qtx11extras";
  propagatedBuildInputs = [ qtbase ];
}
