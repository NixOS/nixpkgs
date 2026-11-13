{
  jsoncpp,
  ...
}@args:

jsoncpp.override (
  {
    secureMemory = true;
  }
  // removeAttrs args [ "jsoncpp" ]
)
