{
  ikiwiki,
  ...
}@args:

ikiwiki.override (
  {
    bazaarSupport = false; # tests broken
    cvsSupport = true;
    docutilsSupport = true;
    gitSupport = true;
    mercurialSupport = true;
    monotoneSupport = true;
    subversionSupport = true;
  }
  // removeAttrs args [ "ikiwiki" ]
)
