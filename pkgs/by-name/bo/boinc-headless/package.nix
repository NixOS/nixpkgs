{
  boinc,
  ...
}@args:

boinc.override (
  {
    headless = true;
  }
  // removeAttrs args [ "boinc" ]
)
