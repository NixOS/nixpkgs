/* === This file is part of Calamares - <https://github.com/calamares> ===
 *
 *   Copyright 2018, Adriaan de Groot <groot@kde.org>
 *
 *   Calamares is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   Calamares is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Calamares. If not, see <http://www.gnu.org/licenses/>.
 */

#include "FileKeeper.h"

#include <QDateTime>
#include <QProcess>
#include <QThread>

#include <GlobalStorage.h>
#include <JobQueue.h>

#include <utils/Logger.h>

FileKeeperJob::FileKeeperJob( QObject* parent )
    : Calamares::CppJob( parent )
{
}


FileKeeperJob::~FileKeeperJob() {}


QString
FileKeeperJob::prettyName() const
{
    return tr( "File keeper Job" );
}

Calamares::JobResult
FileKeeperJob::exec()
{
    return Calamares::JobResult::ok();
}


void
FileKeeperJob::setConfigurationMap( const QVariantMap& configurationMap )
{
    Q_UNUSED( configurationMap );
}

CALAMARES_PLUGIN_FACTORY_DEFINITION( FileKeeperJobFactory, registerPlugin< FileKeeperJob >(); )
