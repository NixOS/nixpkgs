{
  wrapFirefox,
  librewolf-bin-unwrapped,
}:

wrapFirefox librewolf-bin-unwrapped {
  pname = "librewolf-bin";
  extraPrefsFiles = [
    "${librewolf-bin-unwrapped}/lib/librewolf-bin-${librewolf-bin-unwrapped.version}/librewolf.cfg"
  ];
  extraPoliciesFiles = [
    "${librewolf-bin-unwrapped}/lib/librewolf-bin-${librewolf-bin-unwrapped.version}/distribution/extra-policies.json"
  ];
}
