{
  appimageupdate,
  ...
}@args:

appimageupdate.override (
  {
    withQtUI = true;
  }
  // removeAttrs args [ "appimageupdate" ]
)
