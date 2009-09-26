function makeTempFile(prefix)
{
  var file = Components.classes["@mozilla.org/file/directory_service;1"]
                       .getService(Components.interfaces.nsIProperties)
                       .get("TmpD", Components.interfaces.nsIFile);
  file.append(prefix || "xulrunner");
  file.createUnique(Components.interfaces.nsIFile.NORMAL_FILE_TYPE, 0664);
  return file;
}

function writeToFile(file, data)
{
  // file is nsIFile, data is a string
  var foStream = Components.classes["@mozilla.org/network/file-output-stream;1"]
                           .createInstance(Components.interfaces.nsIFileOutputStream);

  // use 0x02 | 0x10 to open file for appending.
  foStream.init(file, 0x02 | 0x08 | 0x20, 0664, 0); // write, create, truncate
  foStream.write(data, data.length);
  foStream.close();
}

function readFromFile(file)
{
  // |file| is nsIFile
  var data = "";
  var fstream = Components.classes["@mozilla.org/network/file-input-stream;1"]
                          .createInstance(Components.interfaces.nsIFileInputStream);
  var sstream = Components.classes["@mozilla.org/scriptableinputstream;1"]
                          .createInstance(Components.interfaces.nsIScriptableInputStream);
  fstream.init(file, -1, 0, 0);
  sstream.init(fstream); 

  var str = sstream.read(4096);
  while (str.length > 0) {
    data += str;
    str = sstream.read(4096);
  }

  sstream.close();
  fstream.close();

  return data;
}

function runProgram(commandLine)
{
  // create an nsILocalFile for the executable
  var file = Components.classes["@mozilla.org/file/local;1"]
                       .createInstance(Components.interfaces.nsILocalFile);
  file.initWithPath("/bin/sh");

  // create an nsIProcess
  var process = Components.classes["@mozilla.org/process/util;1"]
                          .createInstance(Components.interfaces.nsIProcess);
  process.init(file);

  // Run the process.
  // If first param is true, calling thread will be blocked until
  // called process terminates.
  // Second and third params are used to pass command-line arguments
  // to the process.
  var args = ["-c", commandLine];
  process.run(true, args, args.length);
}

// only for testing...
function testIO()
{
  var f = makeTempFile();
  writeToFile(f, "essai\ntest");
  alert(readFromFile(f));
  runProgram("zenity --info");
}
