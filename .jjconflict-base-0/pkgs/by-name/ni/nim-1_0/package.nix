{
  nim-unwrapped-1,
  nim,
}:

nim.passthru.wrapNim {
  nimUnwrapped = nim-unwrapped-1;
  patches = [ ./nim.cfg.patch ];
}
