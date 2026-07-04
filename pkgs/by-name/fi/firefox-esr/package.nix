{
  wrapFirefox,
  firefox-esr-unwrapped,
}:

wrapFirefox firefox-esr-unwrapped {
  nameSuffix = "-esr";
  wmClass = "firefox-esr";
  icon = "firefox-esr";
}
