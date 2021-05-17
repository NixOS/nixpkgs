/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2021 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 *
 */

#include "Runners.h"

#include <QFileInfo>

Runner::Runner( const QString& source, const QString& destination )
    : m_source( source )
    , m_destination( destination )
{
}

Runner::~Runner() {}

bool
Runner::checkSourceExists() const
{
    return false;
}
