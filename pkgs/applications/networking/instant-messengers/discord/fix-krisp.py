#!@pythonInterpreter@
# slightly modefied version from the script created by @sersorrel
# https://github.com/sersorrel/sys/blob/main/hm/discord/krisp-patcher.py
"""
This fixes the krisp module not loading.
"""


import subprocess
import re
import signal
import os
import shutil
import sys

from pathlib import Path
from elftools.elf.elffile import ELFFile
from capstone import *
from capstone.x86 import *

def getKrisp():
    process = subprocess.Popen(sys.argv[1], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=False, universal_newlines=True, preexec_fn=os.setsid)
    print("[Nix] Leting Discord download Krisp")
    try:
        for line in iter(process.stdout.readline, ''):
            print(line, end='')
            if re.search("installed-module discord_krisp", line):
                os.killpg(os.getpgid(process.pid), signal.SIGTERM)
                print("[Nix] Finished downloading Krisp")
                break
    finally:
        process.wait()
        process.stdout.close()


XDG_CONFIG_HOME = os.environ.get("XDG_CONFIG_HOME") or os.path.join(
    os.path.expanduser("~"), ".config"
)

executable = f"{XDG_CONFIG_HOME}/@configDirName@/@version@/modules/discord_krisp/discord_krisp.node"

if (not os.path.exists(Path(executable))):
    print("[Nix] Krisp not found")
    getKrisp()

elf = ELFFile(open(executable, "rb"))
symtab = elf.get_section_by_name('.symtab')

krisp_initialize_address = symtab.get_symbol_by_name("_ZN7discord15KrispInitializeEv")[0].entry.st_value
isSignedByDiscord_address = symtab.get_symbol_by_name("_ZN7discord4util17IsSignedByDiscordERKNSt2Cr12basic_stringIcNS1_11char_traitsIcEENS1_9allocatorIcEEEE")[0].entry.st_value

text = elf.get_section_by_name('.text')
text_start = text['sh_addr']
text_start_file = text['sh_offset']
# This seems to always be zero (.text starts at the right offset in the file). Do it just in case?
address_to_file = text_start_file - text_start

# Done with the ELF now.
# elf.close()

krisp_initialize_offset = krisp_initialize_address - address_to_file
isSignedByDiscord_offset = krisp_initialize_address - address_to_file

f = open(executable, "rb")
f.seek(krisp_initialize_offset)
krisp_initialize = f.read(64)
f.close()

# States
found_issigned_by_discord_call = False
found_issigned_by_discord_test = False
found_issigned_by_discord_je = False
found_already_patched = False
je_location = None

# We are looking for a call to IsSignedByDiscord, followed by a test, followed by a je.
# Then we patch the je into a two byte nop.

md = Cs(CS_ARCH_X86, CS_MODE_64)
md.detail = True
for i in md.disasm(krisp_initialize, krisp_initialize_address):
    if i.id == X86_INS_CALL:
        if i.operands[0].type == X86_OP_IMM:
            if i.operands[0].imm == isSignedByDiscord_address:
                found_issigned_by_discord_call = True

    if i.id == X86_INS_TEST:
        if found_issigned_by_discord_call:
            found_issigned_by_discord_test = True

    if i.id == X86_INS_JE:
        if found_issigned_by_discord_test:
            found_issigned_by_discord_je = True
            je_location = i.address
            break

    if i.id == X86_INS_NOP:
        if found_issigned_by_discord_test:
            found_already_patched = True
            break

if je_location:
    print(f"[Nix] Found patch location: 0x{je_location:x}")

    shutil.copyfile(executable, executable + ".orig")
    f = open(executable, 'rb+')
    f.seek(je_location - address_to_file)
    f.write(b'\x66\x90')  # Two byte NOP
    f.close()
else:
    if found_already_patched:
        print("[Nix] Couldn't find patch location - already patched.")
    else:
        print("[Nix] Couldn't find patch location - review manually. Sorry.")
