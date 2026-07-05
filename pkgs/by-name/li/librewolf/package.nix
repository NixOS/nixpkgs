{
  wrapFirefox,
  librewolf-unwrapped,
}:

wrapFirefox librewolf-unwrapped {
  inherit (librewolf-unwrapped) extraPrefsFiles extraPoliciesFiles;
  libName = "librewolf";
}
