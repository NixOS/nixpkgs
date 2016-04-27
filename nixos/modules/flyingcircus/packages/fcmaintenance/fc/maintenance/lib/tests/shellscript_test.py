from fc.maintenance.lib.shellscript import ShellScriptActivity

import io
import os


def test_sh_script(tmpdir):
    os.chdir(str(tmpdir))
    script = io.StringIO('echo "hello"; echo "world" >&2; exit 5\n')
    a = ShellScriptActivity(script)
    a.run()
    assert a.stdout == 'hello\n'
    assert a.stderr == 'world\n'
    assert a.returncode == 5


def test_python_script(tmpdir):
    os.chdir(str(tmpdir))
    script = io.StringIO("""\
#!/usr/bin/env python3
import sys
print('hello')
print('world', file=sys.stderr)
sys.exit(5)
""")
    a = ShellScriptActivity(script)
    a.run()
    assert a.stdout == 'hello\n'
    assert a.stderr == 'world\n'
    assert a.returncode == 5
