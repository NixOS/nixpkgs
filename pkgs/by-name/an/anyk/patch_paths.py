from pathlib import Path
from struct import pack
import sys

def to_java_string(string) -> bytes:
  string_bytes = string.encode("utf-8")
  # Java constant pool string entries are prefixed by 0x01 and 16-bit big-endian string length.
  return pack(">BH", 1, len(string_bytes)) + string_bytes

class_file = Path(sys.argv[1])

clazz = class_file.read_bytes()

# We want to fix these package names so they work with the open-source Java EE releases instead of OpenJDK 8.
patches = [
  ( "com/sun/xml/internal/ws/developer/WSBindingProvider", "com/sun/xml/ws/developer/WSBindingProvider" ),
  ( "com/sun/xml/internal/ws/api/message/Header", "com/sun/xml/ws/api/message/Header" ),
  ( "com.sun.xml.internal.ws.transport.http.client.streaming.chunk.size", "com.sun.xml.ws.transport.http.client.streaming.chunk.size" ),
  ( "com/sun/xml/internal/ws/api/message/Headers", "com/sun/xml/ws/api/message/Headers" ),
  ( "(Lorg/w3c/dom/Element;)Lcom/sun/xml/internal/ws/api/message/Header;", "(Lorg/w3c/dom/Element;)Lcom/sun/xml/ws/api/message/Header;" ),
  ( "([Lcom/sun/xml/internal/ws/api/message/Header;)V", "([Lcom/sun/xml/ws/api/message/Header;)V" ),
]

for old, new in patches:
  old_java = to_java_string(old)
  new_java = to_java_string(new)
  assert old_java in clazz
  clazz = clazz.replace(old_java, new_java)
  assert old_java not in clazz
  assert new_java in clazz

assert b".internal." not in clazz

class_file.write_bytes(clazz)

