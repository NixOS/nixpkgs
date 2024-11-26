{ makeDesktopItem, pname, suiteName }:

{
  planmaker = makeDesktopItem {
    name = "${pname}-planmaker";
    desktopName = "${suiteName} PlanMaker";
    icon = "${pname}-pml";
    categories = [ "Office" ];
    exec = "${pname}-planmaker %F";
    tryExec = "${pname}-planmaker";
    mimeTypes = [
      "application/x-pmd"
      "application/x-pmdx"
      "application/x-pmv"
      "application/excel"
      "application/x-excel"
      "application/x-ms-excel"
      "application/x-msexcel"
      "application/x-sylk"
      "application/x-xls"
      "application/xls"
      "application/vnd.ms-excel"
      "application/vnd.stardivision.calc"
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      "application/vnd.openxmlformats-officedocument.spreadsheetml.template"
      "application/vnd.ms-excel.sheet.macroenabled.12"
      "application/vnd.ms-excel.template.macroEnabled.12"
      "application/x-dif"
      "text/spreadsheet"
      "text/csv"
      "application/x-prn"
      "application/vnd.ms-excel.sheet.binary.macroenabled.12"
    ];
    startupWMClass = "pm";
  };

  presentations = makeDesktopItem {
    name = "${pname}-presentations";
    desktopName = "${suiteName} Presentations";
    icon = "${pname}-prl";
    categories = [ "Office" ];
    exec = "${pname}-presentations %F";
    tryExec = "${pname}-presentations";
    mimeTypes = [
      "application/x-prdx"
      "application/x-prvx"
      "application/x-prsx"
      "application/x-prd"
      "application/x-prv"
      "application/x-prs"
      "application/ppt"
      "application/mspowerpoint"
      "application/vnd.ms-powerpoint"
      "application/vnd.openxmlformats-officedocument.presentationml.presentation"
      "application/vnd.ms-powerpoint.presentation.macroenabled.12"
      "application/vnd.openxmlformats-officedocument.presentationml.template"
      "application/vnd.ms-powerpoint.template.macroEnabled.12"
      "application/vnd.ms-powerpoint.slideshow.macroenabled.12"
      "application/vnd.openxmlformats-officedocument.presentationml.slideshow"
    ];
    startupWMClass = "pr";
  };

  textmaker = makeDesktopItem {
    name = "${pname}-textmaker";
    desktopName = "${suiteName} TextMaker";
    icon = "${pname}-tml";
    categories = [ "Office" ];
    exec = "${pname}-textmaker %F";
    tryExec = "${pname}-textmaker";
    mimeTypes = [
      "application/x-tmdx"
      "application/x-tmvx"
      "application/x-tmd"
      "application/x-tmv"
      "application/msword"
      "application/vnd.ms-word"
      "application/x-doc"
      "text/rtf"
      "application/rtf"
      "application/vnd.oasis.opendocument.text"
      "application/vnd.oasis.opendocument.text-template"
      "application/vnd.stardivision.writer"
      "application/vnd.sun.xml.writer"
      "application/vnd.sun.xml.writer.template"
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      "application/vnd.ms-word.document.macroenabled.12"
      "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
      "application/vnd.ms-word.template.macroenabled.12"
      "application/x-pocket-word"
      "application/x-dbf"
      "application/msword-template"
    ];
    startupWMClass = "tm";
  };
}
