{
  gnuradio,
  volk,
  uhdMinimal,
}:
# A build without gui components and other utilities not needed for end user
# libraries
gnuradio.override {
  doWrap = false;
  unwrapped = gnuradio.unwrapped.override {
    volk = volk.override {
      # So it will not reference python
      enableModTool = false;
    };
    uhd = uhdMinimal;
    features = {
      gnuradio-companion = false;
      python-support = false;
      examples = false;
      gr-qtgui = false;
      gr-utils = false;
      gr-modtool = false;
      gr-blocktool = false;
      sphinx = false;
      doxygen = false;
      # Doesn't make it reference python eventually, but makes reverse
      # dependencies require python to use cmake files of GR.
      gr-ctrlport = false;
    };
  };
}
