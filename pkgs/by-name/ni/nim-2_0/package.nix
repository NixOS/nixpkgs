{
  nim-unwrapped-2_0,
  nim-2_2,
}:

nim-2_2.passthru.wrapNim {
  nimUnwrapped = nim-unwrapped-2_0;
  inherit (nim-2_2) patches;
}
