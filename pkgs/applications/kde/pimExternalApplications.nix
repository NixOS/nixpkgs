# Some PIM applications need to call external executables and thus need to be wrapped.
# As these components are also used as a part of `kontact`, they need to be added to its
# wrapper as well. To avoid duplication, these dependencies are defined in this separate file.
# If any application turns out to require calling external applications, please specify them
# in the respective attribute and adjust their derivation, as well as `kontact.nix` accordingly.
{ akonadi
, akonadi-import-wizard
, kaddressbook
, kleopatra
, kmail-account-wizard
, pim-data-exporter
}:

{
  kmailApplications = [ akonadi akonadi-import-wizard kaddressbook kleopatra kmail-account-wizard pim-data-exporter ];
  # further applications:
  #korganizerApplications = [];
}
