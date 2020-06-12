#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# === This file is part of Calamares - <https://github.com/calamares> ===
#
#   Calamares is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   Calamares is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with Calamares. If not, see <http://www.gnu.org/licenses/>.
#
#   SPDX-FileCopyrightText: 2020 Adriaan de Groot <groot@kde.org>
#   SPDX-License-Identifier: GPL-3.0-or-later
#   License-Filename: LICENSES/GPL-3.0

"""
The slowpython module is slow. 
"""

import libcalamares
from time import sleep

import gettext
_ = gettext.translation("calamares-python",
                        localedir=libcalamares.utils.gettext_path(),
                        languages=libcalamares.utils.gettext_languages(),
                        fallback=True).gettext


def pretty_name():
    return _("Slow python job.")

status = _("Slow python step {}/10").format(0)

def pretty_status_message():
    return status

def run():
    """Slow python job."""
    try:
        timeout = int(libcalamares.job.timeout)
    except:
        timeout = 30
        
    if not (3 <= timeout <= 600):
        timeout = 30
        
    libcalamares.utils.debug("Slow python job for {} seconds".format(timeout))
    
    global status
    step = timeout / 10.0
    for x in range(11):
        status = _("Slow python step {}/10").format(x)
        libcalamares.job.setprogress(x / 10.0)
        sleep(step)
    return None
