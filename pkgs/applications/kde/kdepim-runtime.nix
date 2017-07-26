{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-calendar, akonadi-contacts, akonadi-mime, akonadi-notes,
  kalarmcal, kcalutils, kcontacts, kdelibs4support, kidentitymanagement, kimap,
  kmailtransport, kmbox, kmime, knotifyconfig, kross, qtwebengine,
  shared_mime_info
}:

let
  unwrapped =
    kdeApp {
      name = "kdepim-runtime";
      meta = {
        license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
        maintainers = [ lib.maintainers.vandenoever ];
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [
        akonadi akonadi-calendar akonadi-contacts akonadi-mime akonadi-notes
        kalarmcal kcalutils kcontacts kdelibs4support kidentitymanagement
        kimap kmime kmailtransport kmbox knotifyconfig kross qtwebengine
        shared_mime_info
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [
    "bin/akonadi_akonotes_resource"
    "bin/akonadi_birthdays_resource"
    "bin/akonadi_contacts_resource"
    "bin/akonadi_davgroupware_resource"
    "bin/akonadi_ical_resource"
    "bin/akonadi_icaldir_resource"
    "bin/akonadi_imap_resource"
    "bin/akonadi_invitations_agent"
    "bin/akonadi_kalarm_dir_resource"
    "bin/akonadi_kalarm_resource"
    "bin/akonadi_maildir_resource"
    "bin/akonadi_maildispatcher_agent"
    "bin/akonadi_mbox_resource"
    "bin/akonadi_migration_agent"
    "bin/akonadi_mixedmaildir_resource"
    "bin/akonadi_newmailnotifier_agent"
    "bin/akonadi_notes_resource"
    "bin/akonadi_openxchange_resource"
    "bin/akonadi_pop3_resource"
    "bin/akonadi_tomboynotes_resource"
    "bin/akonadi_vcard_resource"
    "bin/akonadi_vcarddir_resource"
    "bin/gidmigrator"
  ];
}
